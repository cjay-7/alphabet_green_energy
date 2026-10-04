import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/form_field_padding.dart';
import '../../../../common_widgets/form_section_card.dart';
import '../../../../common_widgets/phone_number_field.dart';
import '../../../../constants/text.dart';
import '../../controllers/beneficiary_add_controller.dart';

class ZipData {
  final String zip;
  final String state;
  final String district;

  ZipData({
    required this.zip,
    required this.state,
    required this.district,
  });
}

class PersonalDetailsForm extends StatefulWidget {
  const PersonalDetailsForm({super.key});

  @override
  PersonalDetailsFormState createState() => PersonalDetailsFormState();
}

class PersonalDetailsFormState extends State<PersonalDetailsForm> {
  final controller = Get.put(BeneficiaryAddController());
  late List<ZipData> zipData;

  @override
  void initState() {
    super.initState();
    loadZipData();
  }

  Future<void> loadZipData() async {
    try {
      // // Get the path of the directory containing the Dart file
      // String directoryPath = Directory.current.path;
      // // Construct the path to the CSV file
      // String jsonFilePath = '$directoryPath/zips.json';
      // final File file = File(jsonFilePath);
      // // Check if the file exists before attempting to read it
      // if (!file.existsSync()) {
      //   print('Error: zips.json file not found.');
      //   return;
      // }
      //
      // // Read the file contents
      // String jsonData = await file.readAsString();
      String jsonData = await rootBundle.loadString('assets/zipData.json');

      List<dynamic> jsonList = json.decode(jsonData);

      // Convert JSON data to List of ZipData objects
      List<ZipData> zipList = jsonList
          .map((json) => ZipData(
                zip: json['Pincode'],
                state: json['StateName'],
                district: json['Districtname'],
              ))
          .toList();
      // Update the state with the loaded data
      setState(() {
        zipData = zipList;
      });
    } catch (error) {
      print('Error loading JSON data: $error');
    }
  }

  ZipData searchZip(String zip) {
    return zipData.firstWhere(
      (data) => data.zip == zip,
      orElse: () => ZipData(zip: '', state: '', district: ''),
    );
  }

  void updateStateAndDistrict(String zip) {
    ZipData? data = searchZip(zip);
    if (data != null) {
      controller.state.text = data.state;
      controller.district.text = data.district;
    } else {
      controller.state.text = '';
      controller.district.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormSectionCard(
          title: aPersonalDetails,
          children: [
            FormFieldPadding(
              child: TextFormField(
                controller: controller.fullName,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline_outlined),
                  labelText: aFullName,
                  hintText: aFullNameHint,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aFullNameValidator;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.address1,
                decoration: InputDecoration(
                  labelText: aAddress1,
                  prefixIcon: const Icon(Icons.home),
                  hintText: aAddress1Hint,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aAddress1Validator;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.address2,
                decoration: InputDecoration(
                  labelText: aAddress2,
                  prefixIcon: const Icon(Icons.home_outlined),
                  hintText: aAddress2Hint,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aAddress2Validator;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.zip,
                decoration: InputDecoration(
                  labelText: aZipFieldLabel,
                  prefixIcon: const Icon(Icons.pin_drop),
                  hintText: aZipFieldLabel,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aEnterZip;
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.length == 6) {
                    updateStateAndDistrict(value);
                  }
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.state,
                decoration: InputDecoration(
                  labelText: aStateFieldLabel,
                  prefixIcon: const Icon(Icons.terrain),
                  hintText: aStateFieldLabel,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aEnterState;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.district,
                decoration: InputDecoration(
                  labelText: aDistrictFieldLabel,
                  prefixIcon: const Icon(Icons.location_city),
                  hintText: aDistrictFieldLabel,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aEnterDistrict;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.town,
                decoration: InputDecoration(
                  labelText: aTown,
                  prefixIcon: const Icon(Icons.holiday_village),
                  hintText: aTown,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aTownValidator;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: PhoneNumberField(
                initialValue: controller.phoneNumber.text,
                onChanged: (value) => controller.phoneNumber.text = value,
                validator: validatePhoneNumber,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
