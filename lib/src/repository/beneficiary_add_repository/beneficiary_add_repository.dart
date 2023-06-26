// ignore_for_file: avoid_print

import 'package:alphabet_green_energy/src/features/existing_beneficiary/models/add_beneficiary_visit_model.dart';
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
        .doc(beneficiary.idNumber)
        .set(beneficiary.toJson())
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

  Future<void> checkAndSetVisitData(
      String idNumber, AddBeneficiaryVisitModel addVisit) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference visitCollectionRef =
        db.collection("BeneficiaryData").doc(idNumber).collection("VisitData");

    // Check if Visit1 exists
    DocumentSnapshot visit1Snapshot =
        await visitCollectionRef.doc("Visit1").get();

    if (visit1Snapshot.exists) {
      // Visit1 exists, find the next available Visit document
      int nextVisitNumber = 2;
      while (true) {
        DocumentSnapshot visitSnapshot =
            await visitCollectionRef.doc("Visit$nextVisitNumber").get();
        if (!visitSnapshot.exists) {
          // Set the data to the next available Visit document
          await visitCollectionRef
              .doc("Visit$nextVisitNumber")
              .set(addVisit.toJson())
              .then((value) {
            Get.snackbar(
              "Success",
              "Visit details have been added",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green,
            );
          }).catchError((error) {
            Get.snackbar(
              "Error",
              "Something went wrong. Try again",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              colorText: Colors.red,
            );
            print("ERROR - $error");
          });
          break;
        }
        nextVisitNumber++;
      }
    } else {
      // Visit1 does not exist, set the data to Visit1
      await visitCollectionRef
          .doc("Visit1")
          .set(addVisit.toJson())
          .then((value) {
        Get.snackbar(
          "Success",
          "Visit details have been added",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }).catchError((error) {
        Get.snackbar(
          "Error",
          "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
        print("ERROR - $error");
      });
    }
  }

  Future<BeneficiaryModel> getBeneficiaryDetails(String stoveID) async {
    final snapshot = await _db
        .collection("BeneficiaryData")
        .where("StoveID", isEqualTo: stoveID)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final beneficiaryData =
          snapshot.docs.map((e) => BeneficiaryModel.fromSnapshot(e)).single;
      return beneficiaryData;
    } else {
      throw Exception("No beneficiary data found for the provided stoveID");
    }
  }
}
