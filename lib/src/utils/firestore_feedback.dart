// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Runs a Firestore write and shows the same success/error snackbar every
/// repository in this app already shows by hand.
///
/// Mirrors the existing `.whenComplete(...).catchError(...)` chain exactly,
/// including that `whenComplete` always runs before the completion is
/// forwarded — so on a failed write, the success snackbar still briefly
/// shows before the error snackbar replaces it. That's a pre-existing quirk,
/// not something this helper is meant to fix.
Future<void> withFirestoreFeedback(
  Future<void> Function() operation, {
  required String successMessage,
  String successTitle = "Success",
  String errorTitle = "Error",
  String errorMessage = "Something went wrong. Try again",
}) {
  return operation().whenComplete(() {
    Get.snackbar(successTitle, successMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green);
  }).catchError((error, stackTrace) {
    Get.snackbar(errorTitle, errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red);
    print("ERROR - $error");
  });
}
