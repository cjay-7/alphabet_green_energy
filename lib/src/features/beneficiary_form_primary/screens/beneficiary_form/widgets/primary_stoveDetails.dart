import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';

import '../../../../../common_widgets/customInputFormatter.dart';
import '../../../../../constants/text.dart';
import '../../../controllers/primary_beneficiary_add_controller.dart';

class PrimaryStoveDetails extends StatefulWidget {
  const PrimaryStoveDetails({Key? key}) : super(key: key);

  @override
  State<PrimaryStoveDetails> createState() => _StoveDetailsState();
}

class _StoveDetailsState extends State<PrimaryStoveDetails> {
  final controller = Get.put(PrimaryBeneficiaryAddController());

  File? _imageFile;
  UploadTask? uploadTask;
  final picker = ImagePicker();

  bool isImageUploaded = false;
  bool isUploading = false;

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
      controller.stoveImg = _imageFile!.path;
      isImageUploaded = true;
      isUploading = false;
    });
  }

  Future<void> uploadImageToFirebase() async {
    String fileName = basename(_imageFile!.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('files/$fileName');

    // Get the current location
    LocationData locationData = await Location().getLocation();
    double latitude = locationData.latitude ?? 0.0;
    double longitude = locationData.longitude ?? 0.0;

    // Create custom metadata
    final newMetadata = SettableMetadata(
      customMetadata: {
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      },
    );

    // Upload the image
    await firebaseStorageRef.putFile(_imageFile!);

    // Set custom metadata for the uploaded file
    final metadata = await firebaseStorageRef.updateMetadata(newMetadata);

    // Print the metadata to verify
    print(await firebaseStorageRef.getMetadata());

    controller.stoveImg = await firebaseStorageRef.getDownloadURL();

    setState(() {
      isImageUploaded = true;
    });
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
              "Stove Details",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.stoveID,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fireplace),
                labelText: "Enter Stove ID",
                hintText: "Stove ID",
                hintStyle: Theme.of(context).textTheme.bodySmall,
                border: const OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter,
                CustomInputFormatter()
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter Stove ID";
                }
                return null;
              },
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
