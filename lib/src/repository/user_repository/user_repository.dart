// ignore_for_file: avoid_print

import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../constants/firestore_keys.dart';
import '../../utils/firestore_feedback.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) {
    print("Adding user data to Firestore: ${user.toJson()}");
    return withFirestoreFeedback(
      () => _db.collection(FirestoreCollections.users).add(user.toJson()),
      successMessage: "Your account has been created.",
    );
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db
        .collection(FirestoreCollections.users)
        .where(UserFields.email, isEqualTo: email)
        .get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUser() async {
    final snapshot = await _db.collection(FirestoreCollections.users).get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }
}
