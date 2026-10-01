// ignore_for_file: avoid_print

import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../constants/firestore_keys.dart';
import '../../utils/firestore_feedback.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user, String uid) {
    // Every new signup starts pending — a Cloud Function (notifyAdminsOnSignup)
    // emails the admins an Approve/Deny link, and nothing flips this to
    // "approved" except that function. Set here, not in UserModel.toJson(),
    // so a later profile edit (which also calls toJson()) can never touch it.
    final Map<String, dynamic> data = {
      ...user.toJson(),
      UserFields.approvalStatus: ApprovalStatus.pending,
    };
    print("Adding user data to Firestore: $data");
    return withFirestoreFeedback(
      () => _db.collection(FirestoreCollections.users).doc(uid).set(data),
      successMessage: "Your account has been created.",
    );
  }

  Future<void> updateUser(String uid, UserModel user) {
    return withFirestoreFeedback(
      () => _db
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update(user.toJson()),
      successMessage: "Your profile has been updated.",
    );
  }

  Future<UserModel> getUserById(String uid) async {
    final doc = await _db.collection(FirestoreCollections.users).doc(uid).get();
    if (!doc.exists) {
      throw Exception("No user profile found for this account.");
    }
    return UserModel.fromSnapshot(doc);
  }

  Future<List<UserModel>> allUser() async {
    final snapshot = await _db.collection(FirestoreCollections.users).get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }
}
