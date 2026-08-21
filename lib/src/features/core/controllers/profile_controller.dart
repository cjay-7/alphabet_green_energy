import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../repository/user_repository/user_repository.dart';
import '../models/user_model.dart'; // Replace 'your_app' with the actual name of your app

class ProfileController extends GetxController {
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  // Define a reactive variable to hold the user data
  Rx<UserModel?> userData = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Fetch once when the controller is first created, not on every
    // Dashboard rebuild — Dashboard used to call getUserData() directly from
    // build() via a fresh FutureBuilder each time, which could fire this
    // multiple times in close succession and crash GetX's snackbar overlay.
    getUserData();
  }

  /// Fetching data doesn't need the app to be visually ready, but showing a
  /// snackbar does — GetX's SnackbarController looks up the Navigator's
  /// Overlay, which isn't mounted yet immediately after Get.offAll()'s page
  /// transition starts. Get.overlayContext isn't a reliable readiness check
  /// here: it returns a child *of the overlay's current content*, which is
  /// null whenever the overlay happens to be empty and can reference a
  /// since-disposed element otherwise — either way it doesn't prove an
  /// Overlay ancestor actually exists for the current route. Ask Flutter
  /// directly via Overlay.maybeOf on the current route's own context.
  Future<bool> _waitForOverlay() async {
    for (var attempt = 0; attempt < 20; attempt++) {
      final context = Get.context;
      if (context != null && Overlay.maybeOf(context) != null) return true;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    return false;
  }

  // Method to save user data locally
  saveUserDataLocally(UserModel userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJsonString = userData.toJsonString();
    prefs.setString('user_data', userDataJsonString);
  }

  Future<void> getUserData() async {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      try {
        final userData = await _userRepo.getUserDetails(email);
        if (userData != null) {
          this.userData.value = userData;
          saveUserDataLocally(userData);
        } else {
          _showSnackbarSafely("Error", "User data not found");
        }
      } catch (e) {
        _showSnackbarSafely("Error", "Failed to fetch user data: $e");
      }
    } else {
      _showSnackbarSafely("Error", "Login to Continue");
    }
  }

  // GetX's SnackbarController schedules its own show() through an internal
  // queue, so a plain try/catch around Get.snackbar() doesn't reliably catch
  // "No Overlay widget found" — the failure surfaces after this call has
  // already returned. Wait until the Overlay genuinely exists instead.
  Future<void> _showSnackbarSafely(String title, String message) async {
    if (!await _waitForOverlay()) return;
    Get.snackbar(title, message);
  }
}
