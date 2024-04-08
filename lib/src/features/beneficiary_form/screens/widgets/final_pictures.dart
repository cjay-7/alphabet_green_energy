import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/beneficiary_add_controller.dart';
import 'package:path/path.dart';

class FinalPictures extends StatefulWidget {
  const FinalPictures({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<FinalPictures> createState() => _FinalPicturesState();
}

class _FinalPicturesState extends State<FinalPictures> {
  final controller = Get.put(BeneficiaryAddController());
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
      if (controller.image1 == "") controller.image1 = _imageFile!.path;
      if (controller.image2 == "") controller.image2 = _imageFile!.path;
      if (controller.image3 == "") controller.image3 = _imageFile!.path;
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
      if (controller.image1 == "") controller.image1 = imageUrl;
      if (controller.image2 == "") controller.image2 = imageUrl;
      if (controller.image3 == "") controller.image3 = imageUrl;
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
              widget.title,
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
                            "Add picture",
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
                                    await uploadImageToFirebase();
                                  } else if (result
                                      .contains(ConnectivityResult.none)) {
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
