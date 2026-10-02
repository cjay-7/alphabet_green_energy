const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const crypto = require("crypto");

admin.initializeApp();

// Field names must match lib/src/constants/firestore_keys.dart exactly —
// this is the Admin SDK, so Firestore security rules don't help catch a typo
// here the way they would on the client.
const USERS_COLLECTION = "Users";
const FIELDS = {
  fullName: "FullName",
  email: "EMail",
  phone: "Phone",
  approvalStatus: "ApprovalStatus",
  approvalToken: "ApprovalToken",
  lastResendAt: "LastResendAt",
};
const STATUS = { pending: "pending", approved: "approved", denied: "denied" };
const RESEND_COOLDOWN_MS = 24 * 60 * 60 * 1000;

// Set once with: firebase functions:secrets:set GMAIL_APP_PASSWORD
// (an App Password for the sender Gmail account, not its login password —
// https://myaccount.google.com/apppasswords). Never stored in source.
const gmailAppPassword = defineSecret("GMAIL_APP_PASSWORD");

// Plain, non-secret config — lives in functions/.env (gitignored, but not a
// credential) so it's easy to change without touching code.
const SENDER_EMAIL = process.env.SENDER_EMAIL;
const ADMIN_EMAILS = (process.env.ADMIN_EMAILS || "")
  .split(",")
  .map((e) => e.trim())
  .filter(Boolean);

function getTransporter() {
  return nodemailer.createTransport({
    service: "gmail",
    auth: { user: SENDER_EMAIL, pass: gmailAppPassword.value() },
  });
}

function functionsBaseUrl(region) {
  // Cloud Functions v2 (Cloud Run-backed) HTTPS URLs don't follow the old
  // v1 "https://<region>-<project>.cloudfunctions.net/<name>" shape, so this
  // is built from the event context instead of hardcoded.
  const project = process.env.GCLOUD_PROJECT;
  return `https://${region}-${project}.cloudfunctions.net`;
}

/**
 * Shared by the initial signup notification and the agent-triggered resend —
 * same email, same links, just invoked from two different places.
 */
async function sendApprovalEmail(uid, data, token) {
  const base = functionsBaseUrl("asia-south1");
  const approveUrl = `${base}/approveSignup?uid=${uid}&token=${token}`;
  const denyUrl = `${base}/denySignup?uid=${uid}&token=${token}`;

  const name = data[FIELDS.fullName] || "(no name given)";
  const email = data[FIELDS.email] || "(no email)";
  const phone = data[FIELDS.phone] || "(no phone)";

  await getTransporter().sendMail({
    from: `Alphabet Green Energy <${SENDER_EMAIL}>`,
    to: ADMIN_EMAILS.join(","),
    subject: `New agent signup awaiting approval: ${name}`,
    html: `
      <p>A new agent signed up and needs approval before they can use the app:</p>
      <ul>
        <li><strong>Name:</strong> ${name}</li>
        <li><strong>Email:</strong> ${email}</li>
        <li><strong>Phone:</strong> ${phone}</li>
      </ul>
      <p>
        <a href="${approveUrl}"
           style="background:#2e7d32;color:#fff;padding:10px 20px;text-decoration:none;border-radius:4px;margin-right:10px;display:inline-block;">
          Approve
        </a>
        <a href="${denyUrl}"
           style="background:#c62828;color:#fff;padding:10px 20px;text-decoration:none;border-radius:4px;display:inline-block;">
          Deny
        </a>
      </p>
      <p style="color:#888;font-size:12px;">Each link works once. If you've already acted on this signup, clicking again will just say so.</p>
    `,
  });

  logger.info(`Approval email sent for ${email} (uid=${uid}).`);
}

/**
 * Fires when a new agent signs up (UserRepository.createUser writes the
 * Users/{uid} doc with ApprovalStatus: "pending"). Generates a one-time
 * approval token, stores it on the doc, and emails the admins an
 * Approve/Deny link pair carrying that token.
 */
exports.notifyAdminsOnSignup = onDocumentCreated(
  // Collocated with the Firestore database's actual region (asia-south1) —
  // deploying this trigger to a different region works but adds an
  // unnecessary cross-region hop between Eventarc and the function.
  { document: `${USERS_COLLECTION}/{uid}`, region: "asia-south1", secrets: [gmailAppPassword] },
  async (event) => {
    const snap = event.data;
    if (!snap) return;
    const data = snap.data();

    if (!ADMIN_EMAILS.length) {
      logger.error("ADMIN_EMAILS is not set — skipping signup notification.");
      return;
    }

    // Defensive: only ever act on a doc that's actually pending (e.g. not a
    // re-trigger from a restore/import carrying an already-decided status).
    if (data[FIELDS.approvalStatus] !== STATUS.pending) return;

    const token = crypto.randomBytes(32).toString("hex");
    await snap.ref.update({
      [FIELDS.approvalToken]: token,
      [FIELDS.lastResendAt]: admin.firestore.FieldValue.serverTimestamp(),
    });

    await sendApprovalEmail(event.params.uid, data, token);
  }
);

/**
 * Shared handler for the Approve/Deny email links. Validates the one-time
 * token against the doc, applies the decision, and deletes the token so the
 * link can't be replayed. Uses the Admin SDK, so this bypasses Firestore
 * rules by design — the rules exist to stop the *client app* from setting
 * its own approval status, not this function.
 */
async function resolveDecision(req, res, status) {
  const uid = String(req.query.uid || "");
  const token = String(req.query.token || "");
  if (!uid || !token) {
    res.status(400).send(renderPage("Missing link parameters.", false));
    return;
  }

  const ref = admin.firestore().collection(USERS_COLLECTION).doc(uid);
  const snap = await ref.get();
  if (!snap.exists) {
    res.status(404).send(renderPage("No such agent account.", false));
    return;
  }

  const data = snap.data();
  const currentStatus = data[FIELDS.approvalStatus];
  const storedToken = data[FIELDS.approvalToken];

  if (!storedToken) {
    // Token already consumed by an earlier click of either link.
    res
      .status(200)
      .send(
        renderPage(
          `Already decided: this agent is currently "${currentStatus}". No action taken.`,
          true
        )
      );
    return;
  }

  if (storedToken !== token) {
    res.status(403).send(renderPage("This link is invalid.", false));
    return;
  }

  await ref.update({
    [FIELDS.approvalStatus]: status,
    [FIELDS.approvalToken]: admin.firestore.FieldValue.delete(),
  });

  const name = data[FIELDS.fullName] || data[FIELDS.email] || uid;
  res
    .status(200)
    .send(
      renderPage(
        `${status === STATUS.approved ? "Approved" : "Denied"}: ${name}`,
        true
      )
    );
}

function renderPage(message, ok) {
  return `<!doctype html>
<html><body style="font-family:sans-serif;text-align:center;padding:48px;">
  <h2>${ok ? "✅" : "⚠️"} ${message}</h2>
</body></html>`;
}

exports.approveSignup = onRequest(
  { region: "asia-south1" },
  (req, res) => resolveDecision(req, res, STATUS.approved)
);

exports.denySignup = onRequest(
  { region: "asia-south1" },
  (req, res) => resolveDecision(req, res, STATUS.denied)
);

/**
 * Fallback for when the original signup email never arrives (spam filter,
 * typo'd ADMIN_EMAILS, etc). Called by the agent themselves from the
 * "Awaiting Approval" screen — authenticated via their own Firebase ID
 * token (not a uid passed in the request body, so one agent can never
 * trigger a resend for another's account), and rate-limited to once per 24h
 * per account so this can't be used to spam the admins' inbox.
 */
exports.resendApprovalEmail = onRequest(
  { region: "asia-south1", secrets: [gmailAppPassword] },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Use POST." });
      return;
    }

    const authHeader = req.get("Authorization") || "";
    const idToken = authHeader.startsWith("Bearer ")
      ? authHeader.slice("Bearer ".length)
      : "";
    if (!idToken) {
      res.status(401).json({ error: "Missing Authorization header." });
      return;
    }

    let uid;
    try {
      uid = (await admin.auth().verifyIdToken(idToken)).uid;
    } catch (e) {
      res.status(401).json({ error: "Invalid or expired session." });
      return;
    }

    const ref = admin.firestore().collection(USERS_COLLECTION).doc(uid);
    const snap = await ref.get();
    if (!snap.exists) {
      res.status(404).json({ error: "No profile found for this account." });
      return;
    }

    const data = snap.data();
    if (data[FIELDS.approvalStatus] !== STATUS.pending) {
      res.status(409).json({
        error: `This account has already been ${data[FIELDS.approvalStatus]}.`,
      });
      return;
    }

    const lastResendAt = data[FIELDS.lastResendAt];
    const lastResendMs = lastResendAt ? lastResendAt.toMillis() : 0;
    const elapsedMs = Date.now() - lastResendMs;
    if (elapsedMs < RESEND_COOLDOWN_MS) {
      const hoursLeft = Math.ceil((RESEND_COOLDOWN_MS - elapsedMs) / 3600000);
      res.status(429).json({
        error: `You can request this again in about ${hoursLeft} hour${hoursLeft === 1 ? "" : "s"}.`,
      });
      return;
    }

    // Reuse the existing token if the original email's links are still
    // live, rather than invalidating them by minting a new one.
    const token = data[FIELDS.approvalToken] || crypto.randomBytes(32).toString("hex");
    await ref.update({
      [FIELDS.approvalToken]: token,
      [FIELDS.lastResendAt]: admin.firestore.FieldValue.serverTimestamp(),
    });

    await sendApprovalEmail(uid, data, token);
    res.status(200).json({ ok: true });
  }
);
