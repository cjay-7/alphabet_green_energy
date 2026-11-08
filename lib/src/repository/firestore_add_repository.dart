import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../constants/firestore_keys.dart';
import '../features/existing_beneficiary/models/add_beneficiary_visit_model.dart';
import '../utils/firestore_feedback.dart';

/// Fields identifying who submitted a record and when, merged into every
/// beneficiary / survey / visit write.
Map<String, dynamic> submissionStamp() {
  final n = DateTime.now();
  final day =
      '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  return {
    SubmissionFields.submittedBy: FirebaseAuth.instance.currentUser?.uid,
    SubmissionFields.submittedDay: day,
    SubmissionFields.submittedAt: FieldValue.serverTimestamp(),
  };
}

/// Shared "write one document to a fixed collection, show the standard
/// success/error snackbar" behavior that every *AddRepository in this app
/// already implemented by hand identically.
abstract class FirestoreAddRepository<TModel> extends GetxController {
  String get collectionName;
  String get entityLabel;
  String docIdFor(TModel model);
  Map<String, dynamic> toJson(TModel model);

  final db = FirebaseFirestore.instance;

  Future<void> add(TModel model) {
    return withFirestoreFeedback(
      () => db.collection(collectionName).doc(docIdFor(model)).set({...toJson(model), ...submissionStamp()}),
      successMessage: "$entityLabel details have been added to cloud",
    );
  }
}

/// Adds a "find the next unused VisitN subdocument and write to it" method,
/// for the two repositories (Beneficiary, Primary Beneficiary) whose
/// entities can have visit records. Survey has no visits, so it doesn't mix
/// this in.
mixin VisitSubcollectionMixin {
  String get collectionName;
  FirebaseFirestore get db;

  Future<void> checkAndSetVisitData(
      String idNumber, AddBeneficiaryVisitModel addVisit) async {
    final visitCollectionRef = db
        .collection(collectionName)
        .doc(idNumber)
        .collection(FirestoreCollections.visitData);

    var visitNumber = 1;
    while (await visitCollectionRef
        .doc("Visit$visitNumber")
        .get()
        .then((snapshot) => snapshot.exists)) {
      visitNumber++;
    }

    return withFirestoreFeedback(
      () => visitCollectionRef.doc("Visit$visitNumber").set({...addVisit.toJson(), ...submissionStamp()}),
      successMessage: "Visit details have been added to cloud",
    );
  }
}
