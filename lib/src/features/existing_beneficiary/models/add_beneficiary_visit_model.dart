import 'package:cloud_firestore/cloud_firestore.dart';

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
      "StoveImgVisit": stoveImgVisit,
      "usedRegularly": usedRegularly,
      "worksProperly": worksProperly,
      "idNumber": idNumber,
    };
  }

  factory AddBeneficiaryVisitModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AddBeneficiaryVisitModel(
      stoveImgVisit: data["stoveImgVisit"],
      usedRegularly: data["usedRegularly"],
      worksProperly: data["worksProperly"],
      idNumber: data["idNumber"],
    );
  }
  factory AddBeneficiaryVisitModel.fromJson(Map<String, dynamic> json) {
    return AddBeneficiaryVisitModel(
      stoveImgVisit: json["StoveImgVisit"],
      usedRegularly: json["usedRegularly"],
      worksProperly: json["worksProperly"],
      idNumber: json["idNumber"],
    );
  }
}
