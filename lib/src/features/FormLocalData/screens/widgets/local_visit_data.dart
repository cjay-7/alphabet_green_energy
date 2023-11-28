import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/local_storage_controller.dart';

SingleChildScrollView localVisitData(BuildContext context) {
  final localStorageController = Get.put(LocalStorageController());
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (localStorageController.visitDataList.isEmpty)
            const Text('No saved Visit data found.'),
          if (localStorageController
              .visitDataList.isNotEmpty) // Check if visitDataList is not empty
            for (var visitData in localStorageController.visitDataList)
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Visit Data",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ListTile(
                      title: visitData.idNumber.isNotEmpty
                          ? Text('Beneficiary idNumber: ${visitData.idNumber}')
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
