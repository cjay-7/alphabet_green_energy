import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../features/beneficiary_form/models/beneficiary_model.dart';

class BeneficiaryAddRepository extends GetxController {
  static BeneficiaryAddRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  addData(BeneficiaryModel beneficiary) async {
    await _db
        .collection("BeneficiaryData")
        .add(beneficiary.toJson())
        .whenComplete(() {
      Get.snackbar("Success", "Beneficiary details have been added",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print("ERROR - $error");
    });
  }
}
