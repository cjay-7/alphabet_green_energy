// Read-only diagnostic: print every Users doc id + ApprovalStatus/ApprovalToken.
const admin = require("firebase-admin");
admin.initializeApp({ projectId: "alphabetgreens" });

async function main() {
  const snapshot = await admin.firestore().collection("Users").get();
  snapshot.forEach((doc) => {
    const d = doc.data();
    console.log(JSON.stringify({
      uid: doc.id,
      FullName: d.FullName,
      EMail: d.EMail,
      ApprovalStatus: d.ApprovalStatus,
      hasApprovalToken: "ApprovalToken" in d,
    }));
  });
}

main().catch((e) => { console.error(e); process.exit(1); });
