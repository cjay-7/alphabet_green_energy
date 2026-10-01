import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../constants/firestore_keys.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String profileImageUrl;
  final String approvalStatus;

  const UserModel({
    this.id,
    required this.email,
    required this.phoneNo,
    required this.fullName,
    this.profileImageUrl = '',
    this.approvalStatus = ApprovalStatus.pending,
  });

  // approvalStatus is deliberately left out of toJson(): it's set once at
  // signup (UserRepository.createUser) and afterwards changed only by the
  // admin-approval Cloud Function, never by a client-side profile update.
  // Firestore rules enforce the same thing server-side.
  toJson() {
    return {
      UserFields.fullName: fullName,
      UserFields.email: email,
      UserFields.phone: phoneNo,
      UserFields.profileImage: profileImageUrl,
    };
  }

  // Method to convert UserModel to JSON string
  String toJsonString() {
    return jsonEncode({
      "id": id,
      "email": email,
      "phoneNo": phoneNo,
      "fullName": fullName,
      "profileImageUrl": profileImageUrl,
      "approvalStatus": approvalStatus,
    });
  }

  // Factory method to create UserModel instance from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"] ?? '',
      phoneNo: json["phoneNo"] ?? '',
      fullName: json["fullName"] ?? '',
      profileImageUrl: json["profileImageUrl"] ?? '',
      approvalStatus: json["approvalStatus"] ?? ApprovalStatus.pending,
    );
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        email: data[UserFields.email] ?? '',
        phoneNo: data[UserFields.phone] ?? '',
        fullName: data[UserFields.fullName] ?? '',
        profileImageUrl: data[UserFields.profileImage] ?? '',
        approvalStatus: data[UserFields.approvalStatus] ?? ApprovalStatus.pending);
  }
}
