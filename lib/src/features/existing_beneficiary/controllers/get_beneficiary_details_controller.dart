import 'package:alphabet_green_energy/src/repository/beneficiary_add_repository/beneficiary_add_repository.dart';
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
        print(
            "Fetching beneficiary details for serialNumber: $serialNumber"); // Add this line
        BeneficiaryModel beneficiary =
            await _beneficiaryRepo.getBeneficiaryDetails(serialNumber);
        if (beneficiary != null) {
          beneficiaryList.clear();
          beneficiaryList.add(beneficiary);
        } else {
          Get.snackbar("Error", "No Such Records");
        }
      } catch (error) {
        print("Error fetching beneficiary data: $error"); // Add this line
        Get.snackbar("Error", "An error occurred");
      }
    } else {
      Get.snackbar("Error", "Please enter a Stove ID");
    }
  }
}
