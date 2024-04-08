import 'dart:convert';

import 'package:alphabet_green_energy/src/features/survey_form/screens/widgets/final_pictures.dart';
import 'package:alphabet_green_energy/src/features/survey_form/screens/widgets/fuel_type.dart';
import 'package:alphabet_green_energy/src/features/survey_form/screens/widgets/id_details_form.dart';
import 'package:alphabet_green_energy/src/features/survey_form/screens/widgets/personal_details_form.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/text.dart';

import '../controllers/survey_add_controller.dart';
import '../models/survey_model.dart';

class SurveyForm extends StatefulWidget {
  const SurveyForm({super.key});

  @override
  State<SurveyForm> createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SurveyAddController());

  Future<String> getFullNameFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJsonString = prefs.getString('user_data');
    if (userDataJsonString != null) {
      final userDataMap =
          jsonDecode(userDataJsonString) as Map<String, dynamic>;
      final fullName = userDataMap['fullName'] as String?;
      return fullName!;
    } else {
      return "";
    }
  }

  Future<void> _saveSurveyDataToLocalStorage(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final surveyDataList = prefs.getStringList('surveyData') ?? [];

    surveyDataList.add(jsonEncode(data));

    await prefs.setStringList('surveyData', surveyDataList);
    Get.snackbar("Success", 'Survey data saved locally.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green);
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    // Reset any additional values or state variables if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Survey Form"),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PersonalDetails(),
                        const FinalPictures(),
                        const Divider(),
                        const IdDetails(),
                        const Divider(),
                        const FuelType(),
                        const Divider(),
                        SizedBox(
                          width: double.infinity,
                          height: 60.0,
                          child: FutureBuilder<String>(
                              future: getFullNameFromLocalStorage(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Show a loading indicator while fetching the fullName from local storage
                                  return const CircularProgressIndicator();
                                } else {
                                  // Get the fullName from the snapshot data
                                  final fullName = snapshot.data ?? '';
                                  // Update the surveyorName with the fullName
                                  final surveyorName = fullName;

                                  return OutlinedButton(
                                    onPressed: () async {
                                      var result = await Connectivity()
                                          .checkConnectivity();
                                      if (result.contains(
                                              ConnectivityResult.mobile) ||
                                          result.contains(
                                              ConnectivityResult.wifi)) {
                                        if (_formKey.currentState!.validate() &&
                                            controller.image1.isNotEmpty &&
                                            controller.idImgFront.isNotEmpty) {
                                          _formKey.currentState!.save();

                                          // Get the current date
                                          String currentDate =
                                              DateTime.now().toString();

                                          final survey = SurveyModel(
                                            fullName:
                                                controller.fullName.text.trim(),
                                            address1:
                                                controller.address1.text.trim(),
                                            address2:
                                                controller.address2.text.trim(),
                                            town: controller.town.text.trim(),
                                            state: controller.state.text.trim(),
                                            zip: controller.zip.text.trim(),
                                            phoneNumber: controller
                                                .phoneNumber.text
                                                .trim(),
                                            gender: controller.gender,
                                            idNumber:
                                                controller.idNumber.text.trim(),
                                            idType: controller.idType,
                                            image: controller.image1,
                                            idImageFront: controller.idImgFront,
                                            idImageBack: controller.idImgBack,
                                            fuelType1: controller.fuelType1,
                                            fuelType2: controller.fuelType2,
                                            fuelType1amount: controller
                                                .fuelType1amount.text
                                                .trim(),
                                            fuelType2amount: controller
                                                .fuelType2amount.text
                                                .trim(),
                                            totalPersons: controller
                                                .totalPersons.text
                                                .trim(),
                                            currentDate: currentDate,
                                            surveyorName: surveyorName,
                                          );
                                          SurveyAddController.instance
                                              .addSurveyData(survey);
                                          _resetForm();
                                          Get.back();
                                        }
                                      } else if (result.contains(
                                              ConnectivityResult.none) &&
                                          _formKey.currentState!.validate() &&
                                          controller.image1.isNotEmpty &&
                                          controller.idImgFront.isNotEmpty) {
                                        _formKey.currentState!.save();

                                        // Get the current date
                                        String currentDate =
                                            DateTime.now().toString();

                                        final survey = SurveyModel(
                                          fullName:
                                              controller.fullName.text.trim(),
                                          address1:
                                              controller.address1.text.trim(),
                                          address2:
                                              controller.address2.text.trim(),
                                          town: controller.town.text.trim(),
                                          state: controller.state.text.trim(),
                                          zip: controller.zip.text.trim(),
                                          phoneNumber: controller
                                              .phoneNumber.text
                                              .trim(),
                                          gender: controller.gender,
                                          idNumber:
                                              controller.idNumber.text.trim(),
                                          idType: controller.idType,
                                          image: controller.image1,
                                          idImageFront: controller.idImgFront,
                                          idImageBack: controller.idImgBack,
                                          fuelType1: controller.fuelType1,
                                          fuelType2: controller.fuelType2,
                                          fuelType1amount: controller
                                              .fuelType1amount.text
                                              .trim(),
                                          fuelType2amount: controller
                                              .fuelType2amount.text
                                              .trim(),
                                          totalPersons: controller
                                              .totalPersons.text
                                              .trim(),
                                          currentDate: currentDate,
                                          surveyorName: surveyorName,
                                        );
                                        await _saveSurveyDataToLocalStorage(
                                            survey.toJson());
                                        _resetForm();
                                        Get.back();
                                      }
                                    },
                                    child: Text(
                                      aSave,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  );
                                }
                              }),
                        )
                      ]),
                ))));
  }
}
