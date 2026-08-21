import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';

/// Shared "upload a file to Storage's files/ folder, tag it with the
/// device's current GPS coordinates as custom metadata, and return its
/// download URL" logic. Previously duplicated across the stove/ID photo
/// upload flows in beneficiary_form, beneficiary_form_primary, and
/// survey_form.
mixin LocationTaggedUploadMixin {
  Future<String> uploadWithLocationTag(File file) async {
    final fileName = basename(file.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('files/$fileName');

    final locationData = await Location().getLocation();
    final latitude = locationData.latitude ?? 0.0;
    final longitude = locationData.longitude ?? 0.0;

    await firebaseStorageRef.putFile(file);
    await firebaseStorageRef.updateMetadata(SettableMetadata(
      customMetadata: {
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      },
    ));

    if (kDebugMode) {
      print(await firebaseStorageRef.getMetadata());
    }

    return firebaseStorageRef.getDownloadURL();
  }
}
