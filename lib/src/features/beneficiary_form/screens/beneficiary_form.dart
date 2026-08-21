import 'dart:convert';

import 'package:alphabet_green_energy/src/features/beneficiary_form/controllers/beneficiary_add_controller.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/models/beneficiary_model.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/widgets/final_pictures.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/widgets/id_details_form.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/widgets/personal_details_form.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/widgets/stove_details.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/text.dart';
import '../../../utils/safe_snackbar.dart';

class BeneficiaryFormWidget extends StatefulWidget {
  const BeneficiaryFormWidget({super.key});

  @override
  BeneficiaryFormWidgetState createState() => BeneficiaryFormWidgetState();
}

class BeneficiaryFormWidgetState extends State<BeneficiaryFormWidget> {
  final controller = Get.put(BeneficiaryAddController());
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
                const StoveDetails(),
                const Divider(),
                PersonalDetailsForm(),
                const Divider(),
                const IdDetails(),
                const Divider(),
                FinalPictures(
                    title:
                        "Add pictures of giving the stove to the Beneficiary",
                    onImageUploaded: (path) {
                      controller.image1 = path;
                      controller.image2 = path;
                      controller.image3 = path;
                    }),
                const Divider(),
                FinalPictures(
                    title: "Add Consent Form",
                    onImageUploaded: (path) => controller.consentImg = path),
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
                              if (result.contains(ConnectivityResult.mobile) ||
                                  result.contains(ConnectivityResult.wifi)) {
                                if (_formKey.currentState!.validate() &&
                                    controller.stoveImg.isNotEmpty &&
                                    controller.image1.isNotEmpty &&
                                    controller.image2.isNotEmpty &&
                                    controller.image3.isNotEmpty &&
                                    controller.consentImg.isNotEmpty &&
                                    controller.idImgFront.isNotEmpty &&
                                    controller.idImgBack.isNotEmpty) {
                                  _formKey.currentState!.save();

                                  // Get the current date
                                  String currentDate =
                                      DateTime.now().toString();
                                  final beneficiary = BeneficiaryModel(
                                    stoveID: controller.stoveID.text.trim(),
                                    fullName: controller.fullName.text.trim(),
                                    address1: controller.address1.text.trim(),
                                    address2: controller.address2.text.trim(),
                                    zip: controller.zip.text.trim(),
                                    state: controller.state.text,
                                    district: controller.district.text,
                                    town: controller.town.text.trim(),
                                    phoneNumber:
                                        controller.phoneNumber.text.trim(),
                                    idNumber: controller.idNumber.text.trim(),
                                    idType: controller.idType,
                                    stoveImg: controller.stoveImg,
                                    image1: controller.image1,
                                    image2: controller.image2,
                                    image3: controller.image3,
                                    idImageFront: controller.idImgFront,
                                    idImageBack: controller.idImgBack,
                                    consentImg: controller.consentImg,
                                    currentDate: currentDate,
                                    surveyorName: surveyorName,
                                  );
                                  BeneficiaryAddController.instance
                                      .addData(beneficiary);
                                  _resetForm();
                                  // Get.back() can silently fail to navigate
                                  // (or throw) if a snackbar from the write
                                  // above is still open/animating — use the
                                  // plain Navigator instead.
                                  Navigator.of(context).pop();
                                }
                              } else if (result
                                      .contains(ConnectivityResult.none) &&
                                  _formKey.currentState!.validate() &&
                                  controller.stoveImg.isNotEmpty &&
                                  controller.image1.isNotEmpty &&
                                  controller.image2.isNotEmpty &&
                                  controller.image3.isNotEmpty &&
                                  controller.consentImg.isNotEmpty &&
                                  controller.idImgFront.isNotEmpty &&
                                  controller.idImgBack.isNotEmpty) {
                                _formKey.currentState!.save();
                                // Get the current date
                                String currentDate = DateTime.now().toString();
                                final beneficiary = BeneficiaryModel(
                                  stoveID: controller.stoveID.text.trim(),
                                  fullName: controller.fullName.text.trim(),
                                  address1: controller.address1.text.trim(),
                                  address2: controller.address2.text.trim(),
                                  zip: controller.zip.text.trim(),
                                  state: controller.state.text,
                                  district: controller.district.text,
                                  town: controller.town.text.trim(),
                                  phoneNumber:
                                      controller.phoneNumber.text.trim(),
                                  idNumber: controller.idNumber.text.trim(),
                                  idType: controller.idType,
                                  stoveImg: controller.stoveImg,
                                  image1: controller.image1,
                                  image2: controller.image2,
                                  image3: controller.image3,
                                  idImageFront: controller.idImgFront,
                                  idImageBack: controller.idImgBack,
                                  consentImg: controller.consentImg,
                                  currentDate: currentDate,
                                  surveyorName: surveyorName,
                                );
                                await _saveFormDataToLocalStorage(
                                    beneficiary.toJson());
                                _resetForm();
                                Navigator.of(context).pop();
                                showSnackbarSafely(
                                    "Success", ' Beneficiary data saved locally.',
                                    backgroundColor:
                                        Colors.green.withOpacity(0.1),
                                    colorText: Colors.green);
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

  Future<void> _saveFormDataToLocalStorage(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final formDataList = prefs.getStringList('formData') ?? [];

    formDataList.add(jsonEncode(data));

    await prefs.setStringList('formData', formDataList);
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    // Reset any additional values or state variables if needed
  }
}
