import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../../../common_widgets/form_field_padding.dart';
import '../../../../common_widgets/form_section_card.dart';
import '../../../../common_widgets/image_upload_field.dart';
import '../../../../constants/text.dart';

class FinalPictures extends StatelessWidget {
  const FinalPictures({
    super.key,
    required this.title,
    required this.onImageUploaded,
  });
  final String title;

  /// Called with the uploaded (or locally-cached) image path/URL once this
  /// picture finishes uploading, so the caller decides which controller
  /// field(s) it belongs to.
  final ValueChanged<String> onImageUploaded;

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
    return FormSectionCard(
      title: title,
      children: [
        FormFieldPadding(
          child: ImageUploadField(
            pickButtonLabel: aAddPicture,
            onUploadOnline: _uploadToFirebase,
            onUploadOffline: _uploadToLocalStorage,
            onUploaded: onImageUploaded,
          ),
        ),
      ],
    );
  }
}
