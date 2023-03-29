// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class BeneficiaryModel {
  final String? id;

  // final File? image1;
  // final File? image2;
  // final File? image3;
  // final File? idImage;
  final String fullName,
      stoveID,
      address1,
      address2,
      town,
      zip,
      phoneNumber,
      idNumber,
      idType;

  const BeneficiaryModel({
    this.id,
    required this.stoveID,
    // required this.image1,
    // required this.image2,
    // required this.image3,
    // required this.idImage,
    required this.fullName,
    required this.address1,
    required this.address2,
    required this.town,
    required this.zip,
    required this.phoneNumber,
    required this.idNumber,
    required this.idType,
  });
  toJson() {
    return {
      "StoveId": stoveID,
      "FullName": fullName,
      "Address1": address1,
      "Address2": address2,
      "Town": town,
      "Zip": zip,
      "PhoneNumber": phoneNumber,
      "IdNumber": idNumber,
      "IdType": idType,
      // "Image1": image1,
      // "Image2": image2,
      // "Image3": image3,
      // "IdImage": idImage,
    };
  }

  factory BeneficiaryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BeneficiaryModel(
      id: document.id,
      stoveID: data["StoveId"],
      fullName: data["FullName"],
      address1: data["Address1"],
      address2: data["Address2"],
      town: data["Town"],
      zip: data["Zip"],
      phoneNumber: data["PhoneNumber"],
      idNumber: data["IdNumber"],
      idType: data["IdType"],
      // image1: data["Image1"],
      // image2: data["Image1"],
      // image3: data["Image1"],
      // idImage: data["IdImage"]
    );
  }
}
