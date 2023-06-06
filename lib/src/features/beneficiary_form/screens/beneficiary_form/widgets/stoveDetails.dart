import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';

import '../../../../../constants/text.dart';
import '../../../controllers/beneficiary_add_controller.dart';

class StoveDetails extends StatefulWidget {
  const StoveDetails({Key? key}) : super(key: key);

  @override
  State<StoveDetails> createState() => _StoveDetailsState();
}

class _StoveDetailsState extends State<StoveDetails> {
  final controller = Get.put(BeneficiaryAddController());

  File? _imageFile;
  UploadTask? uploadTask;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(_imageFile!.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('files/$fileName');
    uploadTask = firebaseStorageRef.putFile(_imageFile!);
    TaskSnapshot? taskSnapshot =
        await uploadTask?.whenComplete(() => uploadTask?.snapshot);
    taskSnapshot?.ref.getDownloadURL().then(
          (value) => controller.stoveImg = value,
        );
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
            child: Text("Stove Details",
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.stoveID,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.fireplace),
                  labelText: "Stove ID",
                  hintText: "Stove ID",
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  border: const OutlineInputBorder()),
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      height: 60,
                      child: OutlinedButton(
                        onPressed: () => pickImage(),
                        child: Text(aAddStovePicture,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .17,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          var result = await Connectivity().checkConnectivity();
                          if (result != ConnectivityResult.none) {
                            uploadImageToFirebase();
                          } else if (result == ConnectivityResult.none) {}
                        },
                        child: Text("Upload",
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                  ],
                ),
                Text(
                  fileName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
