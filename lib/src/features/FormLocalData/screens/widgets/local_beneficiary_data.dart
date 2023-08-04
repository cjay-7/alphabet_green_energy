import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/local_storage_controller.dart';

SingleChildScrollView localBeneficiaryData(BuildContext context) {
  final localStorageController = Get.put(LocalStorageController());
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (localStorageController.formDataList.isEmpty)
            const Text('No saved form data found.'),
          for (var formData in localStorageController.formDataList)
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Beneficiary Data",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  ListTile(
                    title: Text('Stove ID: ${formData.stoveID}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Full Name: ${formData.fullName}'),
                        Text('${formData.idType}: ${formData.idNumber}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
