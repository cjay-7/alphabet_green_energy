import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// Shared "upload a local file to Firebase Storage and return its download
/// URL" behavior that used to be duplicated (as `uploadImage` and
/// `uploadImageToFirestore`) on `LocalStorageController`.
class ImageUploadService {
  Future<String> upload(
    String imagePath, {
    String folder = 'images',
    String? fileName,
  }) async {
    final resolvedFileName = fileName ?? File(imagePath).path.split('/').last;
    final ref =
        FirebaseStorage.instance.ref().child('$folder/$resolvedFileName');
    final uploadTask = ref.putFile(File(imagePath));
    final snapshot = await uploadTask.whenComplete(() {});
    return snapshot.ref.getDownloadURL();
  }
}
