import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
                district: json['District'],
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(aPersonalDetails,
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.fullName,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline_outlined),
                      labelText: aFullName,
                      hintText: aFullNameHint,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aFullNameValidator;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.address1,
                  decoration: InputDecoration(
                      labelText: aAddress1,
                      prefixIcon: const Icon(Icons.home),
                      hintText: aAddress1Hint,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aAddress1Validator;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.address2,
                  decoration: InputDecoration(
                      labelText: aAddress2,
                      prefixIcon: const Icon(Icons.home_outlined),
                      hintText: aAddress2Hint,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aAddress2Validator;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.zip,
                  decoration: InputDecoration(
                      labelText: "Zip",
                      prefixIcon: const Icon(Icons.pin_drop),
                      hintText: "Zip",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Zip";
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.state,
                  decoration: InputDecoration(
                      labelText: "State",
                      prefixIcon: const Icon(Icons.terrain),
                      hintText: "State",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter State";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.district,
                  decoration: InputDecoration(
                      labelText: "District",
                      prefixIcon: const Icon(Icons.location_city),
                      hintText: "District",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter District";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.town,
                  decoration: InputDecoration(
                      labelText: aTown,
                      prefixIcon: const Icon(Icons.holiday_village),
                      hintText: aTown,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aTownValidator;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
