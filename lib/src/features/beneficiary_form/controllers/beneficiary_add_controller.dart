import 'package:alphabet_green_energy/src/features/beneficiary_form/models/beneficiary_model.dart';
import 'package:alphabet_green_energy/src/repository/beneficiary_add_repository/beneficiary_add_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeneficiaryAddController extends GetxController {
  static BeneficiaryAddController get instance => Get.find();

  final fullName = TextEditingController();
  final stoveID = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final town = TextEditingController();
  final zip = TextEditingController();
  final phoneNumber = TextEditingController();
  final idNumber = TextEditingController();
  late var idType = "";
  late var stoveImg = "";

  final beneficiaryAddRepo = Get.put(BeneficiaryAddRepository());

  Future<void> addData(BeneficiaryModel beneficiary) async {
    await beneficiaryAddRepo.addData(beneficiary);
  }
}
