import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/local_storage_controller.dart';

SingleChildScrollView localPrimaryBeneficiaryData(BuildContext context) {
  final localStorageController = Get.put(LocalStorageController());
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (localStorageController.primaryBeneficiaryDataList.isEmpty)
            const Text('No saved Primary Beneficiary data found.'),
          for (var primaryBeneficiaryData
              in localStorageController.primaryBeneficiaryDataList)
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Primary Beneficiary Data",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  ListTile(
                    title: Text('Stove ID: ${primaryBeneficiaryData.stoveID}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Full Name: ${primaryBeneficiaryData.fullName}'),
                        Text('Aadhar: ${primaryBeneficiaryData.idNumber}'),
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
