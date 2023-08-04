import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  final String? id, fuelType2amount;

  final String fullName,
      address1,
      address2,
      town,
      zip,
      phoneNumber,
      totalPersons,
      idNumber,
      idType,
      image,
      idImage,
      gender,
      fuelType1,
      fuelType2,
      fuelType1amount,
      surveyorName;

  final DateTime currentDate;

  const SurveyModel({
    this.id,
    required this.image,
    required this.idImage,
    required this.fullName,
    required this.address1,
    required this.address2,
    required this.town,
    required this.zip,
    required this.phoneNumber,
    required this.totalPersons,
    required this.idNumber,
    required this.idType,
    required this.gender,
    required this.fuelType1,
    required this.fuelType2,
    required this.fuelType1amount,
    this.fuelType2amount,
    required this.currentDate,
    required this.surveyorName,
  });

  toJson() {
    return {
      "FullName": fullName,
      "Address1": address1,
      "Address2": address2,
      "Town": town,
      "Zip": zip,
      "PhoneNumber": phoneNumber,
      "Gender": gender,
      "TotalPersons": totalPersons,
      "Image": image,
      "IdType": idType,
      "IdNumber": idNumber,
      "IdImage": idImage,
      "FuelType1": fuelType1,
      "FuelType1amount": fuelType1amount,
      "FuelType2": fuelType2,
      "FuelType2amount": fuelType2amount,
      "currentDate": currentDate,
      "surveyorName": surveyorName,
    };
  }

  factory SurveyModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return SurveyModel(
      id: data["IdNumber"],
      fullName: data["FullName"],
      address1: data["Address1"],
      address2: data["Address2"],
      town: data["Town"],
      zip: data["Zip"],
      phoneNumber: data["PhoneNumber"],
      totalPersons: data["TotalPersons"],
      idNumber: data["IdNumber"],
      idType: data["IdType"],
      image: data["Image"],
      idImage: data["IdImage"],
      gender: data["Gender"],
      fuelType1: data["FuelType1"],
      fuelType2: data["FuelType2"],
      fuelType1amount: data["FuelType1amount"],
      fuelType2amount: data["FuelType2amount"] ? data["FuelType2amount"] : 0,
      currentDate: data["currentDate"],
      surveyorName: data["surveyorName"],
    );
  }

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      fullName: json['FullName'],
      address1: json['Address1'],
      address2: json['Address2'],
      town: json['Town'],
      zip: json['Zip'],
      phoneNumber: json['PhoneNumber'],
      totalPersons: json['TotalPersons'],
      idNumber: json['IdNumber'],
      idType: json['IdType'],
      image: json['Image'],
      idImage: json['IdImage'],
      gender: json['Gender'],
      fuelType1: json['FuelType1'],
      fuelType2: json['FuelType2'],
      fuelType1amount: json['FuelType1amount'],
      fuelType2amount: json['FuelType2amount'],
      currentDate: json["currentDate"],
      surveyorName: json["surveyorName"],
    );
  }
}
