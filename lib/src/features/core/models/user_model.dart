import 'dart:convert';

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
        id: data["Email"],
        email: data["Email"],
        password: data["Password"],
        phoneNo: data["Phone"],
        fullName: data["FullName"]);
  }
}
