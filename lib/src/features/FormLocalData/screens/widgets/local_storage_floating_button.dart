import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../controllers/local_storage_controller.dart';

class LocalStorageFloatingButton extends StatelessWidget {
  final TabController tabController;

  LocalStorageFloatingButton({super.key, required this.tabController});
  final localStorageController = Get.put(LocalStorageController());
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: aAccentColor,
      onPressed: () {
        if (tabController.index == 0) {
          localStorageController.syncFormDataToFirebase();
        } else if (tabController.index == 1) {
          localStorageController.syncVisitDataToFirebase();
        } else {
          localStorageController.syncSurveyDataToFirebase();
        }
      },
      tooltip: 'Sync Data',
      child: const Icon(Icons.cloud_upload),
    );
  }
}
