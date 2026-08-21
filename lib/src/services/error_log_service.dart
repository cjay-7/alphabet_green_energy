import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../constants/firestore_keys.dart';

class ErrorLogService {
  Future<void> writeErrorToFirestore(String error) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.errorLogs)
          .add({
        'timestamp': FieldValue.serverTimestamp(),
        'error_message': error,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error writing error log to Firestore: $e');
      }
    }
  }
}
