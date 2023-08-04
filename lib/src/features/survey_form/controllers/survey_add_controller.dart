import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../repository/survey_add_repository/survey_add_repository.dart';
import '../models/survey_model.dart';

class SurveyAddController extends GetxController {
  static SurveyAddController get instance => Get.find();

  final fullName = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final town = TextEditingController();
  final zip = TextEditingController();
  final phoneNumber = TextEditingController();
  final totalPersons = TextEditingController();
  final idNumber = TextEditingController();
  final fuelType1amount = TextEditingController();
  final fuelType2amount = TextEditingController();
  late var idType = "Aadhar Card";
  late var gender = "Male";
  late var fuelType1 = "Wood";
  late var fuelType2 = "";
  late var idImg = "";
  late var image1 = "";
  late var surveyorName = "";
  late var currentDate = "";

  final surveyAddRepo = Get.put(SurveyAddRepository());

  Future<void> addSurveyData(BuildContext context, SurveyModel survey) async {
    await surveyAddRepo.addSurveyData(survey);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Survey data saved in firebase.'),
      ),
    );
  }
}
