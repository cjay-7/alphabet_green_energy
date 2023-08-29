import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  final String? id, fuelType2amount;

  final String fullName,
      address1,
      address2,
      town,
      state,
      zip,
      phoneNumber,
      totalPersons,
      idNumber,
      idType,
      image,
      idImageFront,
      idImageBack,
      gender,
      fuelType1,
      fuelType2,
      fuelType1amount,
      surveyorName,
      currentDate;

  const SurveyModel({
    this.id,
    required this.image,
    required this.idImageFront,
    required this.idImageBack,
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
    required this.state,
  });

  toJson() {
    return {
      "FullName": fullName,
      "Address1": address1,
      "Address2": address2,
      "Town": town,
      "State": state,
      "Zip": zip,
      "PhoneNumber": phoneNumber,
      "Gender": gender,
      "TotalPersons": totalPersons,
      "Image": image,
      "IdType": idType,
      "IdNumber": idNumber,
      "IdImageFront": idImageFront,
      "IdImageBack": idImageBack,
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
      state: data["State"],
      zip: data["Zip"],
      phoneNumber: data["PhoneNumber"],
      totalPersons: data["TotalPersons"],
      idNumber: data["IdNumber"],
      idType: data["IdType"],
      image: data["Image"],
      idImageFront: data["IdImageFront"],
      idImageBack: data["IdImageBack"],
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
      state: json['State'],
      zip: json['Zip'],
      phoneNumber: json['PhoneNumber'],
      totalPersons: json['TotalPersons'],
      idNumber: json['IdNumber'],
      idType: json['IdType'],
      image: json['Image'],
      idImageFront: json['IdImageFront'],
      idImageBack: json['IdImageBack'],
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
