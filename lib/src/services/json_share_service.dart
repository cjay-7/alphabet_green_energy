import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Shared "encode a cached data list as JSON and open the share sheet"
/// behavior that used to be duplicated across `LocalStorageController`'s
/// `shareFormData`, `sharePrimaryBeneficiaryData`, `shareSurveyData`, and
/// `shareVisitData`.
class JsonShareService {
  Future<void> shareAsJson<T>(
    List<T> items,
    Map<String, dynamic> Function(T item) toJson, {
    required String fileName,
    required String shareText,
    required String errorContext,
  }) async {
    try {
      final jsonData = items.map(toJson).toList();
      final jsonString = jsonEncode(jsonData);

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsString(jsonString);

      await Share.shareXFiles([XFile(tempFile.path)], text: shareText);

      await tempFile.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error during $errorContext: $e');
      }
    }
  }
}
