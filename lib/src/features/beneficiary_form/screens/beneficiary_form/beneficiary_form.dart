import 'dart:convert';

import 'package:alphabet_green_energy/src/features/beneficiary_form/controllers/beneficiary_add_controller.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/models/beneficiary_model.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/beneficiary_form/widgets/final_pictures.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/beneficiary_form/widgets/id_details_form.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/beneficiary_form/widgets/personal_details_form.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/beneficiary_form/widgets/stoveDetails.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/text.dart';

class BeneficiaryFormWidget extends StatefulWidget {
  const BeneficiaryFormWidget({super.key});

  @override
  BeneficiaryFormWidgetState createState() => BeneficiaryFormWidgetState();
}

class BeneficiaryFormWidgetState extends State<BeneficiaryFormWidget> {
  final controller = Get.put(BeneficiaryAddController());
  final _formKey = GlobalKey<FormState>();

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
                // const Divider(),
                personalDetailsForm(context),
                // const Divider(),
                const IdDetails(),
                // const Divider(),
                // const FinalPictures(),
                // const Divider(),
                // const FinalPictures(),
                // const Divider(),
                // const FinalPictures(),
                // const Divider(),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: OutlinedButton(
                    onPressed: () async {
                      var result = await Connectivity().checkConnectivity();
                      if (result != ConnectivityResult.none) {
                        if (_formKey.currentState!.validate()
                            // &&
                            // controller.stoveImg.isNotEmpty &&
                            // controller.image1.isNotEmpty &&
                            // controller.image2.isNotEmpty &&
                            // controller.image3.isNotEmpty &&
                            // controller.idImg.isNotEmpty
                            ) {
                          _formKey.currentState!.save();
                          final beneficiary = BeneficiaryModel(
                            stoveID: controller.stoveID.text.trim(),
                            fullName: controller.fullName.text.trim(),
                            address1: controller.address1.text.trim(),
                            address2: controller.address2.text.trim(),
                            town: controller.town.text.trim(),
                            zip: controller.zip.text.trim(),
                            phoneNumber: controller.phoneNumber.text.trim(),
                            idNumber: controller.idNumber.text.trim(),
                            idType: controller.idType,
                            stoveImg: controller.stoveImg,
                            image1: controller.image1,
                            image2: controller.image2,
                            image3: controller.image3,
                            idImage: controller.idImg,
                          );
                          BeneficiaryAddController.instance
                              .addData(context, beneficiary);
                          _resetForm();
                          Get.back();
                        }
                      } else if (result == ConnectivityResult.none &&
                              _formKey.currentState!.validate()
                          // &&
                          // controller.stoveImg.isNotEmpty &&
                          // controller.image1.isNotEmpty &&
                          // controller.image2.isNotEmpty &&
                          // controller.image3.isNotEmpty &&
                          // controller.idImg.isNotEmpty
                          ) {
                        _formKey.currentState!.save();
                        final beneficiary = BeneficiaryModel(
                          stoveID: controller.stoveID.text.trim(),
                          fullName: controller.fullName.text.trim(),
                          address1: controller.address1.text.trim(),
                          address2: controller.address2.text.trim(),
                          town: controller.town.text.trim(),
                          zip: controller.zip.text.trim(),
                          phoneNumber: controller.phoneNumber.text.trim(),
                          idNumber: controller.idNumber.text.trim(),
                          idType: controller.idType,
                          stoveImg: controller.stoveImg,
                          image1: controller.image1,
                          image2: controller.image2,
                          image3: controller.image3,
                          idImage: controller.idImg,
                        );
                        await _saveFormDataToLocalStorage(
                            context, beneficiary.toJson());
                        _resetForm();
                        Get.back();
                      } else {
                        if (kDebugMode) {
                          if (controller.stoveImg.isEmpty) {
                            print("stoveImg is empty.");
                          }
                          if (controller.image1.isEmpty) {
                            print("image1 is empty.");
                          }
                          if (controller.image2.isEmpty) {
                            print("image2 is empty.");
                          }
                          if (controller.image3.isEmpty) {
                            print("image3 is empty.");
                          }
                          if (controller.idImg.isEmpty) {
                            print("idImg is empty.");
                          }
                        }
                      }
                    },
                    child: Text(
                      aSave,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveFormDataToLocalStorage(
      BuildContext context, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final formDataList = prefs.getStringList('formData') ?? [];

    formDataList.add(jsonEncode(data));

    await prefs.setStringList('formData', formDataList);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form data saved locally.'),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    // Reset any additional values or state variables if needed
  }
}
