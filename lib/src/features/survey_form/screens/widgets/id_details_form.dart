import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import 'package:path/path.dart';

import '../../../../constants/text.dart';
import '../../controllers/survey_add_controller.dart';

class IdDetails extends StatefulWidget {
  const IdDetails({super.key});

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

  File? _Frontimage, _Backimage;
  UploadTask? uploadTask;
  final picker = ImagePicker();

  bool isImageUploaded = false; // Flag to track image upload
  bool isUploading = false; // Flag to track the upload process
  bool isImageUploaded1 = false; // Flag to track image upload
  bool isUploading1 = false; // Flag to track the upload process

  Future pickFrontImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _Frontimage = File(pickedFile!.path);
    });
  }

  Future pickBackImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _Backimage = File(pickedFile!.path);
    });
  }

  Future<void> uploadFrontImageToLocalStorage() async {
    setState(() {
      isUploading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulating upload delay

    setState(() {
      controller.idImgFront = _Frontimage!.path;
    });
    // Simulating upload completion delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isImageUploaded = true;
      isUploading = false;
    });
  }

  Future<void> uploadBackImageToLocalStorage() async {
    setState(() {
      isUploading1 = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulating upload delay

    setState(() {
      controller.idImgBack = _Backimage!.path;
    });
    // Simulating upload completion delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isImageUploaded1 = true;
      isUploading1 = false;
    });
  }

  Future<void> uploadFrontImageToFirebase() async {
    setState(() {
      isUploading = true; // Set the loading flag to true
    });

    String fileName = basename(_Frontimage!.path);
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
    await firebaseStorageRef.putFile(_Frontimage!);

    // Set custom metadata for the uploaded file
    final metadata = await firebaseStorageRef.updateMetadata(newMetadata);

    // Print the metadata to verify
    if (kDebugMode) {
      print(await firebaseStorageRef.getMetadata());
    }
    try {
      await uploadTask?.whenComplete(() {});
      final imageUrl = await firebaseStorageRef.getDownloadURL();

      controller.idImgFront = imageUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      // Handle any errors that occurred during the upload process
    } finally {
      setState(() {
        isImageUploaded = true;
        isUploading = false; // Set the loading flag back to false
      });
    }
  }

  Future<void> uploadBackImageToFirebase() async {
    setState(() {
      isUploading1 = true; // Set the loading flag to true
    });

    String fileName = basename(_Backimage!.path);
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
    await firebaseStorageRef.putFile(_Backimage!);

    // Set custom metadata for the uploaded file
    final metadata = await firebaseStorageRef.updateMetadata(newMetadata);

    // Print the metadata to verify
    if (kDebugMode) {
      print(await firebaseStorageRef.getMetadata());
    }

    try {
      await uploadTask?.whenComplete(() {});
      final imageUrl = await firebaseStorageRef.getDownloadURL();

      controller.idImgBack = imageUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      // Handle any errors that occurred during the upload process
    } finally {
      setState(() {
        isImageUploaded1 = true;
        isUploading1 = false; // Set the loading flag back to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileNameFront =
        _Frontimage != null ? basename(_Frontimage!.path) : 'No File Selected';
    final fileNameBack =
        _Backimage != null ? basename(_Backimage!.path) : 'No File Selected';
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
                          onPressed: () => pickFrontImage(),
                          child: Text(
                            aIDPhotoFront,
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
                          onPressed: (_Frontimage == null || isUploading)
                              ? null
                              : () async {
                                  var result =
                                      await Connectivity().checkConnectivity();
                                  if (result.contains(
                                          ConnectivityResult.mobile) ||
                                      result
                                          .contains(ConnectivityResult.wifi)) {
                                    uploadFrontImageToFirebase();
                                  } else if (result
                                      .contains(ConnectivityResult.none)) {
                                    uploadFrontImageToLocalStorage();
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
                fileNameFront,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: OutlinedButton(
                          onPressed: () => pickBackImage(),
                          child: Text(
                            aIDPhotoBack,
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
                          onPressed: (_Backimage == null || isUploading)
                              ? null
                              : () async {
                                  var result =
                                      await Connectivity().checkConnectivity();
                                  if (result.contains(
                                          ConnectivityResult.mobile) ||
                                      result
                                          .contains(ConnectivityResult.wifi)) {
                                    uploadBackImageToFirebase();
                                  } else if (result
                                      .contains(ConnectivityResult.none)) {
                                    uploadBackImageToLocalStorage();
                                  }
                                },
                          icon: isUploading1
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
                              : isImageUploaded1
                                  ? const Icon(Icons.check)
                                  : const Icon(Icons.upload),
                          label: Text(
                            isImageUploaded1 ? 'Uploaded' : 'Upload',
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
                fileNameBack,
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
