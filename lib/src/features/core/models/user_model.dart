import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;

  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.phoneNo,
    required this.fullName,
  });
  toJson() {
    return {
      "FullName": fullName,
      "EMail": email,
      "Phone": phoneNo,
      "Password": password,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: data["Email"],
        email: data["Email"],
        password: data["Password"],
        phoneNo: data["Phone"],
        fullName: data["FullName"]);
  }
}
