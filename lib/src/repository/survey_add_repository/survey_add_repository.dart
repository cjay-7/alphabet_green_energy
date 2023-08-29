// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../features/survey_form/models/survey_model.dart';

class SurveyAddRepository extends GetxController {
  static SurveyAddRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  addSurveyData(SurveyModel survey) async {
    await _db
        .collection("SurveyData")
        .doc(survey.idNumber)
        .set(survey.toJson())
        .whenComplete(() {
      Get.snackbar("Success", "Survey details have been added to cloud",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print("ERROR - $error");
    });
  }
}
