import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repository/primary_beneficiary_add_repository/primary_beneficiary_add_repository.dart';
import '../models/primary_beneficiary_model.dart';

class PrimaryBeneficiaryAddController extends GetxController {
  static PrimaryBeneficiaryAddController get instance => Get.find();

  final fullName = TextEditingController();
  final stoveID = TextEditingController(text: 'AL-V2-24-');
  final phoneNumber = TextEditingController();
  final idNumber = TextEditingController();
  late var stoveImg = "";
  late var idImgFront = "";
  late var idImgBack = "";
  late var image1 = "";

  final primaryBeneficiaryAddRepo = Get.put(PrimaryBeneficiaryAddRepository());

  Future<void> addPrimaryData(
      PrimaryBeneficiaryModel primaryBeneficiary) async {
    await primaryBeneficiaryAddRepo
        .addPrimaryBeneficiaryData(primaryBeneficiary);
  }
}
