import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../constants/firestore_keys.dart';

class BeneficiaryModel {
  final String? id;

  final String fullName,
      stoveID,
      stoveImg,
      address1,
      address2,
      zip,
      town,
      state,
      district,
      phoneNumber,
      idNumber,
      idType,
      image1,
      image2,
      image3,
      idImageFront,
      idImageBack,
      consentImg,
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
    required this.consentImg,
    required this.fullName,
    required this.address1,
    required this.address2,
    required this.zip,
    required this.town,
    required this.state,
    required this.district,
    required this.phoneNumber,
    required this.idNumber,
    required this.idType,
    required this.currentDate,
    required this.surveyorName,
  });

  toJson() {
    return {
      BeneficiaryFields.stoveID: stoveID,
      BeneficiaryFields.stoveImg: stoveImg,
      BeneficiaryFields.fullName: fullName,
      BeneficiaryFields.address1: address1,
      BeneficiaryFields.address2: address2,
      BeneficiaryFields.zip: zip,
      BeneficiaryFields.state: state,
      BeneficiaryFields.district: district,
      BeneficiaryFields.town: town,
      BeneficiaryFields.phoneNumber: phoneNumber,
      BeneficiaryFields.idNumber: idNumber,
      BeneficiaryFields.idType: idType,
      BeneficiaryFields.image1: image1,
      BeneficiaryFields.image2: image2,
      BeneficiaryFields.image3: image3,
      BeneficiaryFields.idImageFront: idImageFront,
      BeneficiaryFields.idImageBack: idImageBack,
      BeneficiaryFields.consentImg: consentImg,
      BeneficiaryFields.currentDate: currentDate,
      BeneficiaryFields.surveyorName: surveyorName,
    };
  }

  factory BeneficiaryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BeneficiaryModel(
      id: data[BeneficiaryFields.idNumber],
      stoveID: data[BeneficiaryFields.stoveID],
      stoveImg: data[BeneficiaryFields.stoveImg],
      fullName: data[BeneficiaryFields.fullName],
      address1: data[BeneficiaryFields.address1],
      address2: data[BeneficiaryFields.address2],
      zip: data[BeneficiaryFields.zip],
      state: data[BeneficiaryFields.state],
      district: data[BeneficiaryFields.district],
      town: data[BeneficiaryFields.town],
      phoneNumber: data[BeneficiaryFields.phoneNumber],
      idNumber: data[BeneficiaryFields.idNumber],
      idType: data[BeneficiaryFields.idType],
      image1: data[BeneficiaryFields.image1],
      image2: data[BeneficiaryFields.image2],
      image3: data[BeneficiaryFields.image3],
      idImageFront: data[BeneficiaryFields.idImageFront],
      idImageBack: data[BeneficiaryFields.idImageBack],
      consentImg: data[BeneficiaryFields.consentImg] ?? '',
      currentDate: data[BeneficiaryFields.currentDate],
      surveyorName: data[BeneficiaryFields.surveyorName],
    );
  }

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      stoveID: json[BeneficiaryFields.stoveID],
      stoveImg: json[BeneficiaryFields.stoveImg],
      fullName: json[BeneficiaryFields.fullName],
      address1: json[BeneficiaryFields.address1],
      address2: json[BeneficiaryFields.address2],
      zip: json[BeneficiaryFields.zip],
      state: json[BeneficiaryFields.state],
      district: json[BeneficiaryFields.district],
      town: json[BeneficiaryFields.town],
      phoneNumber: json[BeneficiaryFields.phoneNumber],
      idNumber: json[BeneficiaryFields.idNumber],
      idType: json[BeneficiaryFields.idType],
      image1: json[BeneficiaryFields.image1],
      image2: json[BeneficiaryFields.image2],
      image3: json[BeneficiaryFields.image3],
      idImageFront: json[BeneficiaryFields.idImageFront],
      idImageBack: json[BeneficiaryFields.idImageBack],
      consentImg: json[BeneficiaryFields.consentImg] ?? '',
      currentDate: json[BeneficiaryFields.currentDate],
      surveyorName: json[BeneficiaryFields.surveyorName],
    );
  }
}
