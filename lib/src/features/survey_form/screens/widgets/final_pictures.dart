import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../../../../common_widgets/form_field_padding.dart';
import '../../../../common_widgets/form_section_card.dart';
import '../../../../common_widgets/image_upload_field.dart';
import '../../../../constants/text.dart';
import '../../controllers/survey_add_controller.dart';

class FinalPictures extends StatelessWidget {
  const FinalPictures({super.key});

  Future<String> _uploadToFirebase(File file) async {
    final fileName = basename(file.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('files/$fileName');
    await firebaseStorageRef.putFile(file).whenComplete(() {});
    return firebaseStorageRef.getDownloadURL();
  }

  Future<String> _uploadToLocalStorage(File file) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulating upload delay
    await Future.delayed(const Duration(seconds: 2)); // Simulating completion
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SurveyAddController());
    return FormSectionCard(
      title: aAddPictureOfSurveyee,
      children: [
        FormFieldPadding(
          child: ImageUploadField(
            pickButtonLabel: aSurveyeePhoto,
            onUploadOnline: _uploadToFirebase,
            onUploadOffline: _uploadToLocalStorage,
            onUploaded: (result) => controller.image1 = result,
          ),
        ),
      ],
    );
  }
}
