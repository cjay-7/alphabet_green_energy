import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../constants/firestore_keys.dart';

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
      PrimaryBeneficiaryFields.stoveID: stoveID,
      PrimaryBeneficiaryFields.stoveImg: stoveImg,
      PrimaryBeneficiaryFields.fullName: fullName,
      PrimaryBeneficiaryFields.phoneNumber: phoneNumber,
      PrimaryBeneficiaryFields.idNumber: idNumber,
      PrimaryBeneficiaryFields.image1: image1,
      PrimaryBeneficiaryFields.idImageFront: idImageFront,
      PrimaryBeneficiaryFields.idImageBack: idImageBack,
      PrimaryBeneficiaryFields.currentDate: currentDate,
      PrimaryBeneficiaryFields.surveyorName: surveyorName,
    };
  }

  factory PrimaryBeneficiaryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return PrimaryBeneficiaryModel(
      id: data[PrimaryBeneficiaryFields.idNumber],
      stoveID: data[PrimaryBeneficiaryFields.stoveID],
      stoveImg: data[PrimaryBeneficiaryFields.stoveImg],
      fullName: data[PrimaryBeneficiaryFields.fullName],
      phoneNumber: data[PrimaryBeneficiaryFields.phoneNumber],
      idNumber: data[PrimaryBeneficiaryFields.idNumber],
      image1: data[PrimaryBeneficiaryFields.image1],
      idImageFront: data[PrimaryBeneficiaryFields.idImageFront],
      idImageBack: data[PrimaryBeneficiaryFields.idImageBack],
      currentDate: data[PrimaryBeneficiaryFields.currentDate],
      surveyorName: data[PrimaryBeneficiaryFields.surveyorName],
    );
  }

  factory PrimaryBeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return PrimaryBeneficiaryModel(
      stoveID: json[PrimaryBeneficiaryFields.stoveID],
      stoveImg: json[PrimaryBeneficiaryFields.stoveImg],
      fullName: json[PrimaryBeneficiaryFields.fullName],
      phoneNumber: json[PrimaryBeneficiaryFields.phoneNumber],
      idNumber: json[PrimaryBeneficiaryFields.idNumber],
      image1: json[PrimaryBeneficiaryFields.image1],
      idImageFront: json[PrimaryBeneficiaryFields.idImageFront],
      idImageBack: json[PrimaryBeneficiaryFields.idImageBack],
      currentDate: json[PrimaryBeneficiaryFields.currentDate],
      surveyorName: json[PrimaryBeneficiaryFields.surveyorName],
    );
  }
}
