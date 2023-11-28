import 'package:cloud_firestore/cloud_firestore.dart';

class PrimaryBeneficiaryModel {
  final String? id;

  final String fullName,
      stoveID,
      stoveImg,
      phoneNumber,
      idNumber,
      image1,
      idImageFront,
      idImageBack,
      surveyorName,
      currentDate;

  const PrimaryBeneficiaryModel({
    this.id,
    required this.stoveID,
    required this.stoveImg,
    required this.image1,
    required this.idImageFront,
    required this.idImageBack,
    required this.fullName,
    required this.phoneNumber,
    required this.idNumber,
    required this.currentDate,
    required this.surveyorName,
  });

  toJson() {
    return {
      "StoveID": stoveID,
      "StoveImg": stoveImg,
      "FullName": fullName,
      "PhoneNumber": phoneNumber,
      "IdNumber": idNumber,
      "Image1": image1,
      "IdImageFront": idImageFront,
      "IdImageBack": idImageBack,
      "currentDate": currentDate,
      "surveyorName": surveyorName,
    };
  }

  factory PrimaryBeneficiaryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return PrimaryBeneficiaryModel(
      id: data["IdNumber"],
      stoveID: data["StoveID"],
      stoveImg: data["StoveImg"],
      fullName: data["FullName"],
      phoneNumber: data["PhoneNumber"],
      idNumber: data["IdNumber"],
      image1: data["Image1"],
      idImageFront: data["IdImageFront"],
      idImageBack: data["IdImageBack"],
      currentDate: data["currentDate"],
      surveyorName: data["surveyorName"],
    );
  }

  factory PrimaryBeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return PrimaryBeneficiaryModel(
      stoveID: json['StoveID'],
      stoveImg: json['StoveImg'],
      fullName: json['FullName'],
      phoneNumber: json['PhoneNumber'],
      idNumber: json['IdNumber'],
      image1: json['Image1'],
      idImageFront: json['IdImageFront'],
      idImageBack: json['IdImageBack'],
      currentDate: json["currentDate"],
      surveyorName: json["surveyorName"],
    );
  }
}
