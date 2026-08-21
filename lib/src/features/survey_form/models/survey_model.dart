import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../constants/firestore_keys.dart';

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
      SurveyFields.fullName: fullName,
      SurveyFields.address1: address1,
      SurveyFields.address2: address2,
      SurveyFields.town: town,
      SurveyFields.state: state,
      SurveyFields.zip: zip,
      SurveyFields.phoneNumber: phoneNumber,
      SurveyFields.gender: gender,
      SurveyFields.totalPersons: totalPersons,
      SurveyFields.image: image,
      SurveyFields.idType: idType,
      SurveyFields.idNumber: idNumber,
      SurveyFields.idImageFront: idImageFront,
      SurveyFields.idImageBack: idImageBack,
      SurveyFields.fuelType1: fuelType1,
      SurveyFields.fuelType1amount: fuelType1amount,
      SurveyFields.fuelType2: fuelType2,
      SurveyFields.fuelType2amount: fuelType2amount,
      SurveyFields.currentDate: currentDate,
      SurveyFields.surveyorName: surveyorName,
    };
  }

  factory SurveyModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return SurveyModel(
      id: data[SurveyFields.idNumber],
      fullName: data[SurveyFields.fullName],
      address1: data[SurveyFields.address1],
      address2: data[SurveyFields.address2],
      town: data[SurveyFields.town],
      state: data[SurveyFields.state],
      zip: data[SurveyFields.zip],
      phoneNumber: data[SurveyFields.phoneNumber],
      totalPersons: data[SurveyFields.totalPersons],
      idNumber: data[SurveyFields.idNumber],
      idType: data[SurveyFields.idType],
      image: data[SurveyFields.image],
      idImageFront: data[SurveyFields.idImageFront],
      idImageBack: data[SurveyFields.idImageBack],
      gender: data[SurveyFields.gender],
      fuelType1: data[SurveyFields.fuelType1],
      fuelType2: data[SurveyFields.fuelType2],
      fuelType1amount: data[SurveyFields.fuelType1amount],
      fuelType2amount: data[SurveyFields.fuelType2amount],
      currentDate: data[SurveyFields.currentDate],
      surveyorName: data[SurveyFields.surveyorName],
    );
  }

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      fullName: json[SurveyFields.fullName],
      address1: json[SurveyFields.address1],
      address2: json[SurveyFields.address2],
      town: json[SurveyFields.town],
      state: json[SurveyFields.state],
      zip: json[SurveyFields.zip],
      phoneNumber: json[SurveyFields.phoneNumber],
      totalPersons: json[SurveyFields.totalPersons],
      idNumber: json[SurveyFields.idNumber],
      idType: json[SurveyFields.idType],
      image: json[SurveyFields.image],
      idImageFront: json[SurveyFields.idImageFront],
      idImageBack: json[SurveyFields.idImageBack],
      gender: json[SurveyFields.gender],
      fuelType1: json[SurveyFields.fuelType1],
      fuelType2: json[SurveyFields.fuelType2],
      fuelType1amount: json[SurveyFields.fuelType1amount],
      fuelType2amount: json[SurveyFields.fuelType2amount],
      currentDate: json[SurveyFields.currentDate],
      surveyorName: json[SurveyFields.surveyorName],
    );
  }
}
