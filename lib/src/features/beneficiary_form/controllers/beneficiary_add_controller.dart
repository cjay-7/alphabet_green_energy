import 'package:alphabet_green_energy/src/features/beneficiary_form/models/beneficiary_model.dart';
import 'package:alphabet_green_energy/src/repository/beneficiary_add_repository/beneficiary_add_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeneficiaryAddController extends GetxController {
  static BeneficiaryAddController get instance => Get.find();

  final fullName = TextEditingController();
  final stoveID = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final town = TextEditingController();
  final state = TextEditingController();
  final zip = TextEditingController();
  final phoneNumber = TextEditingController();
  final idNumber = TextEditingController();
  late var idType = "Aadhar Card";
  late var stoveImg = "";
  late var idImgFront = "";
  late var idImgBack = "";
  late var image1 = "";
  late var image2 = "";
  late var image3 = "";

  final beneficiaryAddRepo = Get.put(BeneficiaryAddRepository());

  Future<void> addData(BeneficiaryModel beneficiary) async {
    await beneficiaryAddRepo.addData(beneficiary);
  }
}
