import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../constants/firestore_keys.dart';

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
      UserFields.fullName: fullName,
      UserFields.email: email,
      UserFields.phone: phoneNo,
      UserFields.password: password,
    };
  }

  // Method to convert UserModel to JSON string
  String toJsonString() {
    return jsonEncode({
      "id": id,
      "email": email,
      "password": password,
      "phoneNo": phoneNo,
      "fullName": fullName,
    });
  }

  // Factory method to create UserModel instance from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      phoneNo: json["phoneNo"],
      fullName: json["fullName"],
    );
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: data["id"],
        email: data[UserFields.email],
        password: data[UserFields.password],
        phoneNo: data[UserFields.phone],
        fullName: data[UserFields.fullName]);
  }
}
