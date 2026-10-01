/**
 * One-time maintenance script: marks every existing Users doc that predates
 * the admin-approval feature as "approved", so current field agents aren't
 * locked out of the Dashboard the instant firestore.rules / the Cloud
 * Functions in this directory are deployed. Only touches docs that don't
 * already have an ApprovalStatus field — never overwrites a real pending or
 * denied decision made after that point.
 *
 * Run this BEFORE deploying firestore.rules and the functions, using
 * Application Default Credentials (gcloud auth application-default login)
 * or GOOGLE_APPLICATION_CREDENTIALS pointing at a service account key with
 * Firestore access:
 *
 *   cd functions && node scripts/backfillApprovalStatus.js
 */
const admin = require("firebase-admin");

admin.initializeApp({ projectId: "alphabetgreens" });

async function main() {
  const snapshot = await admin.firestore().collection("Users").get();
  const toBackfill = snapshot.docs.filter(
    (doc) => !("ApprovalStatus" in doc.data())
  );

  for (const doc of toBackfill) {
    await doc.ref.update({ ApprovalStatus: "approved" });
  }

  console.log(
    `Backfilled ApprovalStatus="approved" on ${toBackfill.length} of ${snapshot.size} existing user(s).`
  );
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
