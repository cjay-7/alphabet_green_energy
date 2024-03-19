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
    return Obx(() {
      bool isUploading = localStorageController.isUploading.value;

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: aAccentColor,
            onPressed: isUploading
                ? null // Disable the button when uploading
                : () {
                    if (tabController.index == 0) {
                      localStorageController
                          .syncPrimaryBeneficiaryDataToFirebase();
                    } else if (tabController.index == 1) {
                      localStorageController.syncFormDataToFirebase();
                    } else if (tabController.index == 2) {
                      localStorageController.syncVisitDataToFirebase();
                    } else if (tabController.index == 3) {
                      localStorageController.syncSurveyDataToFirebase();
                    }
                  },
            tooltip: 'Sync Data',
            child: isUploading
                ? const CircularProgressIndicator() // Show a loading indicator when uploading
                : const Icon(Icons.cloud_upload),
          ),
          const SizedBox(height: 16), // Add some spacing between the buttons
          FloatingActionButton(
            backgroundColor: aAccentColor,
            onPressed: isUploading
                ? null // Disable the button when uploading
                : () {
                    if (tabController.index == 0) {
                      localStorageController.sharePrimaryBeneficiaryData();
                    } else if (tabController.index == 1) {
                      localStorageController.shareFormData();
                    } else if (tabController.index == 2) {
                      localStorageController.shareVisitData();
                    } else if (tabController.index == 3) {
                      localStorageController.shareSurveyData();
                    }
                  },
            tooltip: 'Share Data',
            child: const Icon(Icons.share),
          ),
        ],
      );
    });
  }
}
