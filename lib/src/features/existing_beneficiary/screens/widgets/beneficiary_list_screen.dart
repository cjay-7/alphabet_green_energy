import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/text.dart';
import '../../controllers/add_beneficiary_visit_controller.dart';
import '../../controllers/get_beneficiary_details_controller.dart';
import '../../models/add_beneficiary_visit_model.dart';
import 'beneficiary_details.dart';

class BeneficiaryListScreen extends StatefulWidget {
  const BeneficiaryListScreen({super.key});

  @override
  BeneficiaryListScreenState createState() => BeneficiaryListScreenState();
}

class BeneficiaryListScreenState extends State<BeneficiaryListScreen> {
  BeneficiaryListScreenState() {
    usedRegularly = _usedRegularlyList[0];
    worksProperly = _worksProperlyList[0];
  }
  final _usedRegularlyList = ["Yes", "No", "Rarely"];
  String? usedRegularly = "";
  final _worksProperlyList = ["Yes", "No", "Rarely"];
  String? worksProperly = "";

  final addBeneficiaryVisitController =
      Get.put(AddBeneficiaryVisitController());
  final BeneficiaryController _beneficiaryController = Get.find();
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  UploadTask? uploadTask;
  final picker = ImagePicker();

  bool isImageUploaded = false; // New flag to track image upload
  bool isUploading = false; // New flag to track the upload process

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> uploadImageToLocalStorage() async {
    if (_imageFile != null) {
      setState(() {
        isUploading = true;
      });

      await Future.delayed(
          const Duration(seconds: 2)); // Simulating upload delay

      setState(() {
        addBeneficiaryVisitController.stoveImgVisit = _imageFile!.path;
        isImageUploaded = true;
        isUploading = false;
      });
    } else {
      // Handle the case where no image file is selected
    }
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(_imageFile!.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('files/$fileName');
    uploadTask = firebaseStorageRef.putFile(_imageFile!);
    TaskSnapshot? taskSnapshot =
        await uploadTask?.whenComplete(() => uploadTask?.snapshot);
    taskSnapshot?.ref.getDownloadURL().then((value) {
      setState(() {
        addBeneficiaryVisitController.stoveImgVisit = value;
        isImageUploaded = true; // Set the flag to true after successful upload
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileName =
        _imageFile != null ? basename(_imageFile!.path) : 'No File Selected';
    final size = MediaQuery.of(context).size;

    Future<ConnectivityResult> checkConnectivity() async {
      final List<ConnectivityResult> result =
          await Connectivity().checkConnectivity();
      return result.isNotEmpty ? result.first : ConnectivityResult.none;
    }

    String? idNumber = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beneficiary Details'),
      ),
      body: Obx(
        () {
          if (_beneficiaryController.beneficiaryList.isEmpty) {
            idNumber = ModalRoute.of(context)?.settings.arguments as String?;
            return revisitForm(context, fileName, idNumber!);
          } else {
            return FutureBuilder<ConnectivityResult>(
              future: checkConnectivity(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator while checking connectivity
                }
                if (snapshot.hasData &&
                    snapshot.data != ConnectivityResult.none) {
                  idNumber = _beneficiaryController.beneficiaryList[0].idNumber;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        BeneficiaryDetails(
                          size: size,
                          beneficiaryController: _beneficiaryController,
                        ),
                        revisitForm(context, fileName, idNumber!),
                      ],
                    ),
                  );
                } else {
                  idNumber =
                      ModalRoute.of(context)?.settings.arguments as String?;
                  return revisitForm(context, fileName, idNumber!);
                }
              },
            );
          }
        },
      ),
    );
  }

  Form revisitForm(BuildContext context, String fileName, String idNumber) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 20.0,
            ),
            child: Text(
              "Revisit Form",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DropdownSearch(
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    selectedItem: usedRegularly,
                    items: _usedRegularlyList,
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Is it used regularly",
                        prefixIcon: Icon(Icons.timer),
                      ),
                    ),
                    onChanged: (val) {
                      addBeneficiaryVisitController.usedRegularly =
                          val as String;
                    },
                    validator: (item) {
                      if (item == null) {
                        return "Select an Option";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: DropdownSearch(
              popupProps: const PopupProps.menu(
                showSearchBox: true,
              ),
              selectedItem: worksProperly,
              items: _worksProperlyList,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Is it working properly",
                  prefixIcon: Icon(Icons.work_history),
                ),
              ),
              onChanged: (val) {
                addBeneficiaryVisitController.worksProperly = val as String;
              },
              validator: (item) {
                if (item == null) {
                  return "Select an Option";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: OutlinedButton(
                          onPressed: () => pickImage(),
                          child: Text(
                            aAddStovePicture,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: (_imageFile == null || isUploading)
                              ? null
                              : () async {
                                  var result =
                                      await Connectivity().checkConnectivity();
                                  if (result
                                          .contains(ConnectivityResult.wifi) ||
                                      result.contains(
                                          ConnectivityResult.mobile)) {
                                    setState(() {
                                      isUploading = true;
                                    });
                                    uploadImageToFirebase();
                                  } else if (result
                                      .contains(ConnectivityResult.none)) {
                                    uploadImageToLocalStorage();
                                  }
                                },
                          icon: isImageUploaded
                              ? const Icon(Icons.check) // Show check mark icon
                              : const Icon(Icons.upload),
                          label: Text(
                            isImageUploaded
                                ? "Uploaded"
                                : isUploading
                                    ? "Uploading..."
                                    : "Upload",
                            style: GoogleFonts.montserrat(
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 60.0,
              child: OutlinedButton(
                onPressed: () async {
                  var result = await Connectivity().checkConnectivity();
                  if (result.contains(ConnectivityResult.wifi) ||
                      result.contains(ConnectivityResult.mobile)) {
                    if (_formKey.currentState!.validate() &&
                        addBeneficiaryVisitController.stoveImgVisit != '') {
                      _formKey.currentState!.save();

                      final addVisit = AddBeneficiaryVisitModel(
                        stoveImgVisit:
                            addBeneficiaryVisitController.stoveImgVisit,
                        usedRegularly:
                            addBeneficiaryVisitController.usedRegularly,
                        worksProperly:
                            addBeneficiaryVisitController.worksProperly,
                        idNumber: idNumber,
                      );
                      AddBeneficiaryVisitController.instance
                          .addVisitData(addVisit, idNumber);
                      _resetForm();
                      Get.back();
                    }
                  } else if (result.contains(ConnectivityResult.none) &&
                      _formKey.currentState!.validate() &&
                      addBeneficiaryVisitController.stoveImgVisit != "") {
                    _formKey.currentState!.save();
                    final addVisit = AddBeneficiaryVisitModel(
                      stoveImgVisit:
                          addBeneficiaryVisitController.stoveImgVisit,
                      usedRegularly:
                          addBeneficiaryVisitController.usedRegularly,
                      worksProperly:
                          addBeneficiaryVisitController.worksProperly,
                      idNumber: idNumber,
                    );
                    await _saveVisitDataToLocalStorage(addVisit.toJson());

                    _resetForm();
                    Get.back();
                  }
                },
                child: Text(
                  aSave,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveVisitDataToLocalStorage(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final visitDataList = prefs.getStringList('visitData') ?? [];

    visitDataList.add(jsonEncode(data));

    await prefs.setStringList('visitData', visitDataList);

    Get.snackbar("Success", 'Visit data saved locally.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green);
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    // Reset any additional values or state variables if needed
  }
}
