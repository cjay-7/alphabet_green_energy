import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';

import '../../../../constants/text.dart';
import '../../controllers/survey_add_controller.dart';

class IdDetails extends StatefulWidget {
  const IdDetails({Key? key}) : super(key: key);

  @override
  State<IdDetails> createState() => _IdDetailsState();
}

class _IdDetailsState extends State<IdDetails> {
  final controller = Get.put(SurveyAddController());
  _IdDetailsState() {
    idType = _idList[0];
  }
  final _idList = ["Aadhar Card", "Voter Card", "Pan Card", "Ration Card"];
  String? idType = "";

  File? _imageFile;
  UploadTask? uploadTask;
  final picker = ImagePicker();

  bool isImageUploaded = false; // Flag to track image upload
  bool isUploading = false; // Flag to track the upload process

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> uploadImageToLocalStorage() async {
    setState(() {
      isUploading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulating upload delay

    setState(() {
      controller.idImg = _imageFile!.path;
      isImageUploaded = true;
      isUploading = false;
    });
  }

  Future<void> uploadImageToFirebase() async {
    setState(() {
      isUploading = true; // Set the loading flag to true
    });

    String fileName = basename(_imageFile!.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('files/$fileName');
    uploadTask = firebaseStorageRef.putFile(_imageFile!);

    try {
      await uploadTask?.whenComplete(() {});
      final imageUrl = await firebaseStorageRef.getDownloadURL();
      setState(() {
        controller.idImg = imageUrl;
        isImageUploaded = true;
      });
    } catch (e) {
      print('Error uploading image: $e');
      // Handle any errors that occurred during the upload process
    } finally {
      setState(() {
        isUploading = false; // Set the loading flag back to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName =
        _imageFile != null ? basename(_imageFile!.path) : 'No File Selected';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  aIdentificationDetails,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: DropdownSearch(
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                        ),
                        selectedItem: idType,
                        items: _idList,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: aIdentificationType,
                            prefixIcon: Icon(Icons.add_card_rounded),
                          ),
                        ),
                        onChanged: (val) {
                          controller.idType = val as String;
                        },
                        validator: (item) {
                          if (item == null) {
                            return aIDNoValidator;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.idNumber,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline_outlined),
                    labelText: aIDNo,
                    hintText: aIDNo,
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aIDNoValidator;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: OutlinedButton(
                          onPressed: () => pickImage(),
                          child: Text(
                            aIDPhoto,
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
                                  if (result != ConnectivityResult.none) {
                                    uploadImageToFirebase();
                                  } else if (result ==
                                      ConnectivityResult.none) {
                                    uploadImageToLocalStorage();
                                  }
                                },
                          icon: isUploading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : isImageUploaded
                                  ? const Icon(Icons.check)
                                  : const Icon(Icons.upload),
                          label: Text(
                            isImageUploaded ? 'Uploaded' : 'Upload',
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
              ),
              const SizedBox(height: 5),
              Text(
                fileName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
