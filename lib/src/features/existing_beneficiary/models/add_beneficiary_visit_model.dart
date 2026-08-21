import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../constants/firestore_keys.dart';

class AddBeneficiaryVisitModel {
  final String stoveImgVisit, usedRegularly, worksProperly, idNumber;

  const AddBeneficiaryVisitModel({
    required this.stoveImgVisit,
    required this.usedRegularly,
    required this.worksProperly,
    required this.idNumber,
  });

  toJson() {
    return {
      VisitFields.stoveImgVisit: stoveImgVisit,
      VisitFields.usedRegularly: usedRegularly,
      VisitFields.worksProperly: worksProperly,
      VisitFields.idNumber: idNumber,
    };
  }

  factory AddBeneficiaryVisitModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AddBeneficiaryVisitModel(
      stoveImgVisit: data[VisitFields.stoveImgVisit],
      usedRegularly: data[VisitFields.usedRegularly],
      worksProperly: data[VisitFields.worksProperly],
      idNumber: data[VisitFields.idNumber],
    );
  }
  factory AddBeneficiaryVisitModel.fromJson(Map<String, dynamic> json) {
    return AddBeneficiaryVisitModel(
      stoveImgVisit: json[VisitFields.stoveImgVisit],
      usedRegularly: json[VisitFields.usedRegularly],
      worksProperly: json[VisitFields.worksProperly],
      idNumber: json[VisitFields.idNumber],
    );
  }
}
