import 'package:alphabet_green_energy/src/repository/beneficiary_add_repository/beneficiary_add_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../beneficiary_form/models/beneficiary_model.dart';

class BeneficiaryController extends GetxController {
  static BeneficiaryController get instance => Get.find();

  final BeneficiaryAddRepository _beneficiaryRepo =
      Get.put(BeneficiaryAddRepository());

  final TextEditingController stoveID = TextEditingController();
  final TextEditingController idNumber = TextEditingController();
  final RxList<BeneficiaryModel> beneficiaryList = <BeneficiaryModel>[].obs;

  Future<void> getBeneficiaryData(
      String serialNumber, BeneficiaryController beneficiaryController) async {
    if (serialNumber.isNotEmpty) {
      try {
        print("Fetching beneficiary details for serialNumber: $serialNumber");
        BeneficiaryModel beneficiary =
            await _beneficiaryRepo.getBeneficiaryDetails(serialNumber);
        if (beneficiary != null) {
          beneficiaryList.clear();
          beneficiaryList.add(beneficiary);
        } else {
          // No beneficiary data found for the provided serial number
          Get.snackbar("Error",
              "No beneficiary data found for the provided serial number");
        }
      } catch (error) {
        // Handle other exceptions
        print("Error fetching beneficiary data: $error");
        Get.snackbar("Error", "An error occurred: $error");
      }
    } else {
      Get.snackbar("Error", "Please enter a Stove ID");
    }
  }
}
