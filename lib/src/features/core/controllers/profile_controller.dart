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

  // Method to save user data locally
  saveUserDataLocally(UserModel userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJsonString = userData.toJsonString();
    prefs.setString('user_data', userDataJsonString);
  }

  Future<void> getUserData() async {
    // onInit() runs while Get.offAll()'s page transition (500ms, see
    // main.dart) may still be in flight — Get.snackbar needs a settled
    // Overlay, so wait for the transition to finish before any snackbar
    // call below can run.
    await Future<void>.delayed(const Duration(milliseconds: 600));
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

  // GetX's snackbar overlay can still throw (e.g. "No Overlay widget found")
  // if it's triggered while a page transition hasn't fully settled, even
  // after the delay above. This is feedback, not the actual state update
  // (already applied above), so failing to show it shouldn't surface as an
  // unhandled exception.
  void _showSnackbarSafely(String title, String message) {
    try {
      Get.snackbar(title, message);
    } catch (_) {}
  }
}
