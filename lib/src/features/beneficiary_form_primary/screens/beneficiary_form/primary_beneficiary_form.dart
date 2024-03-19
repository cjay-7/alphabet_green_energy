import 'dart:convert';

import 'package:alphabet_green_energy/src/features/beneficiary_form_primary/screens/beneficiary_form/widgets/primary_final_pictures.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form_primary/screens/beneficiary_form/widgets/primary_id_details_form.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form_primary/screens/beneficiary_form/widgets/primary_personal_details_form.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form_primary/screens/beneficiary_form/widgets/primary_stoveDetails.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/text.dart';
import '../../controllers/primary_beneficiary_add_controller.dart';
import '../../models/primary_beneficiary_model.dart';

class PrimaryBeneficiaryFormWidget extends StatefulWidget {
  const PrimaryBeneficiaryFormWidget({super.key});

  @override
  PrimaryBeneficiaryFormWidgetState createState() =>
      PrimaryBeneficiaryFormWidgetState();
}

class PrimaryBeneficiaryFormWidgetState
    extends State<PrimaryBeneficiaryFormWidget> {
  final controller = Get.put(PrimaryBeneficiaryAddController());
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(aAddBeneficiaryAppbar),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PrimaryStoveDetails(),
                const Divider(),
                primaryPersonalDetailsForm(context),
                const Divider(),
                const PrimaryIdDetails(),
                const Divider(),
                const PrimaryFinalPictures(),
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
                              var result =
                                  await Connectivity().checkConnectivity();
                              if (result != ConnectivityResult.none) {
                                if (_formKey.currentState!.validate() &&
                                    controller.stoveImg.isNotEmpty &&
                                    // controller.image1.isNotEmpty &&
                                    // controller.image2.isNotEmpty &&
                                    // controller.image3.isNotEmpty &&
                                    controller.idImgFront.isNotEmpty &&
                                    controller.idImgBack.isNotEmpty) {
                                  _formKey.currentState!.save();

                                  // Get the current date
                                  String currentDate =
                                      DateTime.now().toString();
                                  final beneficiary = PrimaryBeneficiaryModel(
                                    stoveID: controller.stoveID.text.trim(),
                                    fullName: controller.fullName.text.trim(),
                                    phoneNumber:
                                        controller.phoneNumber.text.trim(),
                                    idNumber: controller.idNumber.text.trim(),
                                    stoveImg: controller.stoveImg,
                                    image1: controller.image1,
                                    idImageFront: controller.idImgFront,
                                    idImageBack: controller.idImgBack,
                                    currentDate: currentDate,
                                    surveyorName: surveyorName,
                                  );
                                  PrimaryBeneficiaryAddController.instance
                                      .addPrimaryData(beneficiary);
                                  _resetForm();
                                  Get.back();
                                }
                              } else if (result == ConnectivityResult.none &&
                                  _formKey.currentState!.validate() &&
                                  controller.stoveImg.isNotEmpty &&
                                  controller.image1.isNotEmpty &&
                                  controller.idImgFront.isNotEmpty &&
                                  controller.idImgBack.isNotEmpty) {
                                _formKey.currentState!.save();
                                // Get the current date
                                String currentDate = DateTime.now().toString();
                                final beneficiary = PrimaryBeneficiaryModel(
                                  stoveID: controller.stoveID.text.trim(),
                                  fullName: controller.fullName.text.trim(),
                                  phoneNumber:
                                      controller.phoneNumber.text.trim(),
                                  idNumber: controller.idNumber.text.trim(),
                                  stoveImg: controller.stoveImg,
                                  idImageBack: controller.idImgFront,
                                  idImageFront: controller.idImgBack,
                                  currentDate: currentDate,
                                  surveyorName: surveyorName,
                                  image1: controller.image1,
                                );
                                await _savePrimaryBeneficiaryDataToLocalStorage(
                                    beneficiary.toJson());
                                _resetForm();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              aSave,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePrimaryBeneficiaryDataToLocalStorage(
      Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final primaryBeneficiaryDataList =
        prefs.getStringList('primaryBeneficiaryData') ?? [];

    primaryBeneficiaryDataList.add(jsonEncode(data));

    await prefs.setStringList(
        'primaryBeneficiaryData', primaryBeneficiaryDataList);
    Get.snackbar("Success", 'Primary Beneficiary data saved locally.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green);
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    // Reset any additional values or state variables if needed
  }
}
