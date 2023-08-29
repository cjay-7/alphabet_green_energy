import 'package:cloud_firestore/cloud_firestore.dart';

class BeneficiaryModel {
  final String? id;

  final String fullName,
      stoveID,
      stoveImg,
      address1,
      address2,
      town,
      state,
      zip,
      phoneNumber,
      idNumber,
      idType,
      image1,
      image2,
      image3,
      idImageFront,
      idImageBack,
      surveyorName,
      currentDate;

  const BeneficiaryModel({
    this.id,
    required this.stoveID,
    required this.stoveImg,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.idImageFront,
    required this.idImageBack,
    required this.fullName,
    required this.address1,
    required this.address2,
    required this.town,
    required this.state,
    required this.zip,
    required this.phoneNumber,
    required this.idNumber,
    required this.idType,
    required this.currentDate,
    required this.surveyorName,
  });

  toJson() {
    return {
      "StoveID": stoveID,
      "StoveImg": stoveImg,
      "FullName": fullName,
      "Address1": address1,
      "Address2": address2,
      "Town": town,
      "Zip": zip,
      "State": state,
      "PhoneNumber": phoneNumber,
      "IdNumber": idNumber,
      "IdType": idType,
      "Image1": image1,
      "Image2": image2,
      "Image3": image3,
      "IdImageFront": idImageFront,
      "IdImageBack": idImageBack,
      "currentDate": currentDate,
      "surveyorName": surveyorName,
    };
  }

  factory BeneficiaryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BeneficiaryModel(
      id: data["IdNumber"],
      stoveID: data["StoveID"],
      stoveImg: data["StoveImg"],
      fullName: data["FullName"],
      address1: data["Address1"],
      address2: data["Address2"],
      town: data["Town"],
      state: data["State"],
      zip: data["Zip"],
      phoneNumber: data["PhoneNumber"],
      idNumber: data["IdNumber"],
      idType: data["IdType"],
      image1: data["Image1"],
      image2: data["Image2"],
      image3: data["Image3"],
      idImageFront: data["IdImageFront"],
      idImageBack: data["IdImageBack"],
      currentDate: data["currentDate"],
      surveyorName: data["surveyorName"],
    );
  }

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      stoveID: json['StoveID'],
      stoveImg: json['StoveImg'],
      fullName: json['FullName'],
      address1: json['Address1'],
      address2: json['Address2'],
      town: json['Town'],
      state: json['State'],
      zip: json['Zip'],
      phoneNumber: json['PhoneNumber'],
      idNumber: json['IdNumber'],
      idType: json['IdType'],
      image1: json['Image1'],
      image2: json['Image2'],
      image3: json['Image3'],
      idImageFront: json['IdImageFront'],
      idImageBack: json['IdImageBack'],
      currentDate: json["currentDate"],
      surveyorName: json["surveyorName"],
    );
  }
}
