import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/local_storage_controller.dart';

SingleChildScrollView localSurveyData(BuildContext context) {
  final localStorageController = Get.put(LocalStorageController());
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (localStorageController.surveyDataList.isEmpty)
            const Text('No saved Survey data found.'),
          if (localStorageController
              .surveyDataList.isNotEmpty) // Check if visitDataList is not empty
            for (var surveyData in localStorageController.surveyDataList)
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Survey Data",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ListTile(
                      title: surveyData.idNumber.isNotEmpty
                          ? Text('Beneficiary idNumber: ${surveyData.idNumber}')
                          : null,
                    ),
                  ],
                ),
              ),
        ],
      ),
    ),
  );
}
