import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';

/// Shared "upload a file to Storage's files/ folder, tag it with the
/// device's current GPS coordinates as custom metadata, and return its
/// download URL" logic. Previously duplicated across the stove/ID photo
/// upload flows in beneficiary_form and survey_form.
mixin LocationTaggedUploadMixin {
  Future<String> uploadWithLocationTag(File file) async {
    final fileName = basename(file.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('files/$fileName');

    // The actual photo upload is the part that must never be skipped — GPS
    // tagging is best-effort metadata on top of it. Previously the location
    // lookup ran first and its failure (e.g. PlatformException(NO_ACTIVITY,
    // ...), which reliably happens right after returning from the camera
    // intent) aborted the whole method, silently discarding the photo even
    // though the UI still reported "Uploaded".
    await firebaseStorageRef.putFile(file);

    try {
      final locationData = await Location().getLocation();
      final latitude = locationData.latitude ?? 0.0;
      final longitude = locationData.longitude ?? 0.0;
      await firebaseStorageRef.updateMetadata(SettableMetadata(
        customMetadata: {
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
        },
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Could not attach location metadata: $e');
      }
    }

    if (kDebugMode) {
      print(await firebaseStorageRef.getMetadata());
    }

    return firebaseStorageRef.getDownloadURL();
  }
}
