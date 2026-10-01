// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'safe_snackbar.dart';

/// Runs a Firestore write and shows the same success/error snackbar every
/// repository in this app already shows by hand.
///
/// Mirrors the existing `.whenComplete(...).catchError(...)` chain exactly,
/// including that `whenComplete` always runs before the completion is
/// forwarded — so on a failed write, the success snackbar still briefly
/// shows before the error snackbar replaces it. That's a pre-existing quirk,
/// not something this helper is meant to fix.
///
/// Uses showSnackbarSafely rather than a raw Get.snackbar: a write that
/// completes right as its caller navigates away (e.g. signup's auth-state
/// listener firing Get.offAll the instant the account is created) tears
/// down the old route's Overlay out from under a same-frame Get.snackbar
/// call, throwing an unhandled "No Overlay widget found" — confirmed live
/// on the signup flow. showSnackbarSafely polls for a real Overlay first.
Future<void> withFirestoreFeedback(
  Future<void> Function() operation, {
  required String successMessage,
  String successTitle = "Success",
  String errorTitle = "Error",
  String errorMessage = "Something went wrong. Try again",
}) {
  return operation().whenComplete(() {
    showSnackbarSafely(successTitle, successMessage,
        backgroundColor: aSuccessColor.withOpacity(0.1),
        colorText: aSuccessColor);
  }).catchError((error, stackTrace) {
    showSnackbarSafely(errorTitle, errorMessage,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red);
    print("ERROR - $error");
  });
}
