import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../constants/text.dart';
import '../../../controllers/beneficiary_add_controller.dart';
import 'package:path/path.dart';

class FinalPictures extends StatefulWidget {
  const FinalPictures({Key? key}) : super(key: key);

  @override
  State<FinalPictures> createState() => _FinalPicturesState();
}

class _FinalPicturesState extends State<FinalPictures> {
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
      (value) {
        if (controller.image1 == "") controller.image1 = value;
        if (controller.image2 == "") controller.image2 = value;
        if (controller.image3 == "") controller.image3 = value;
      },
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(" Add pictures of stove handed to the beneficiary",
                style: Theme.of(context).textTheme.titleMedium),
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
                        child: Text(aIDPhoto,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .17,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => uploadImageToFirebase(),
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
        ]));
  }
}
