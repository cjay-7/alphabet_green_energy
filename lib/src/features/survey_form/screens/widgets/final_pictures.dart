import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';

import '../../../../constants/text.dart';
import '../../controllers/survey_add_controller.dart';

class FinalPictures extends StatefulWidget {
  const FinalPictures({Key? key}) : super(key: key);

  @override
  State<FinalPictures> createState() => _FinalPicturesState();
}

class _FinalPicturesState extends State<FinalPictures> {
  final controller = Get.put(SurveyAddController());
  File? _imageFile;
  UploadTask? uploadTask;
  final picker = ImagePicker();

  bool isImageUploaded = false; // New flag to track image upload
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

    await Future.delayed(const Duration(seconds: 1)); // Simulating upload delay
    setState(() {
      controller.image1 = _imageFile!.path;
    });

    // Simulating upload completion delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isImageUploaded = true;
      isUploading = false;
    });
  }

  Future<void> uploadImageToFirebase() async {
    setState(() {
      isUploading = true;
    });

    String fileName = basename(_imageFile!.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('files/$fileName');
    uploadTask = firebaseStorageRef.putFile(_imageFile!);

    try {
      await uploadTask?.whenComplete(() {});
      final imageUrl = await firebaseStorageRef.getDownloadURL();
      controller.image1 = imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      // Handle any errors that occurred during the upload process
    } finally {
      setState(() {
        isImageUploaded = true; // Set the flag to true after successful upload
        isUploading = false; // Set the loading flag back to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName =
        _imageFile != null ? basename(_imageFile!.path) : 'No File Selected';
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Add picture of Surveyee",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
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
                            "Surveyee Photo",
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
                                    await uploadImageToFirebase();
                                  } else if (result ==
                                      ConnectivityResult.none) {
                                    await uploadImageToLocalStorage();
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
                              : (isImageUploaded
                                  ? const Icon(
                                      Icons.check) // Show check mark icon
                                  : const Icon(Icons.upload)),
                          label: Text(
                            isImageUploaded ? "Uploaded" : "Upload",
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
        ],
      ),
    );
  }
}
