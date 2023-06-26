import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alphabet_green_energy/src/repository/beneficiary_add_repository/beneficiary_add_repository.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/models/beneficiary_model.dart';
import 'package:alphabet_green_energy/src/features/existing_beneficiary/models/add_beneficiary_visit_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../beneficiary_form/controllers/beneficiary_add_controller.dart';

class FormLocalDataScreen extends StatefulWidget {
  const FormLocalDataScreen({Key? key}) : super(key: key);

  @override
  _FormLocalDataScreenState createState() => _FormLocalDataScreenState();
}

class _FormLocalDataScreenState extends State<FormLocalDataScreen>
    with SingleTickerProviderStateMixin {
  List<BeneficiaryModel> formDataList = [];
  List<AddBeneficiaryVisitModel> visitDataList = [];
  final beneficiaryAddController = Get.put(BeneficiaryAddController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _retrieveFormDataFromLocalStorage();
    _retrieveVisitDataFromLocalStorage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _retrieveFormDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final formData = prefs.getStringList('formData');
    if (formData != null) {
      setState(() {
        formDataList = formData
            .map((data) => BeneficiaryModel.fromJson(jsonDecode(data)))
            .toList();
      });
    }
  }

  Future<void> _retrieveVisitDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final visitData = prefs.getStringList('visitData');
    if (visitData != null) {
      setState(() {
        visitDataList = visitData
            .map((data) => AddBeneficiaryVisitModel.fromJson(jsonDecode(data)))
            .toList();
      });
    }
  }

  Future<void> _syncFormDataToFirebase() async {
    final beneficiaryAddRepo = BeneficiaryAddRepository.instance;

    for (var formData in formDataList) {
      try {
        await beneficiaryAddRepo.addData(formData);
        // Remove synced form data from local storage
        await _removeFormDataFromLocalStorage(formData);
      } catch (e) {
        print('Failed to sync form data to Firebase: $e');
      }
    }

    // Refresh the screen to reflect the updated form data
    _retrieveFormDataFromLocalStorage();
  }

  Future<void> _syncVisitDataToFirebase() async {
    final db = FirebaseFirestore.instance;

    for (var visitData in visitDataList) {
      try {
        final idNumber = visitData.idNumber;
        if (idNumber.isNotEmpty) {
          final visitCollectionRef = db
              .collection("BeneficiaryData")
              .doc(idNumber)
              .collection("VisitData");

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
                    .set(visitData.toJson())
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
                .set(visitData.toJson())
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
        // Remove synced visit data from local storage
        await _removeVisitDataFromLocalStorage(visitData);
      } catch (e) {
        print('Failed to sync visit data to Firebase: $e');
      }
    }

    // Refresh the screen to reflect the updated visit data
    _retrieveVisitDataFromLocalStorage();
  }

  Future<void> _removeFormDataFromLocalStorage(
      BeneficiaryModel formData) async {
    final prefs = await SharedPreferences.getInstance();
    final savedFormData = prefs.getStringList('formData');
    if (savedFormData != null) {
      savedFormData.remove(jsonEncode(formData.toJson()));
      await prefs.setStringList('formData', savedFormData);
    }
  }

  Future<void> _removeVisitDataFromLocalStorage(
      AddBeneficiaryVisitModel visitData) async {
    final prefs = await SharedPreferences.getInstance();
    final savedVisitData = prefs.getStringList('visitData');
    if (savedVisitData != null) {
      savedVisitData.remove(jsonEncode(visitData.toJson()));
      await prefs.setStringList('visitData', savedVisitData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Local Storage Data'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _tabController.index = index;
            });
          },
          tabs: const [
            Tab(text: 'Form Data'),
            Tab(text: 'Visit Data'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (formDataList.isEmpty)
                    const Text('No saved form data found.'),
                  for (var formData in formDataList)
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Beneficiary Data",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          ListTile(
                            title: Text('Stove ID: ${formData.stoveID}'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Full Name: ${formData.fullName}'),
                                Text(
                                    '${formData.idType}: ${formData.idNumber}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (visitDataList.isEmpty)
                    const Text('No saved form data found.'),
                  if (visitDataList
                      .isNotEmpty) // Check if visitDataList is not empty
                    for (var visitData in visitDataList)
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: visitData.idNumber.isNotEmpty
                                  ? Text(
                                      "Visit Data",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    )
                                  : null,
                            ),
                            ListTile(
                                title: Text(
                                    'Stove Img: ${visitData.stoveImgVisit}')),
                            ListTile(
                              title: visitData.idNumber.isNotEmpty
                                  ? Text(
                                      'Beneficiary idNumber: ${visitData.idNumber}')
                                  : null,
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _syncFormDataToFirebase();
          } else {
            _syncVisitDataToFirebase();
          }
        },
        tooltip: 'Sync Data',
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }
}
