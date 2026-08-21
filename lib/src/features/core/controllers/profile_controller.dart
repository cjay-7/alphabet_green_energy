import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../repository/user_repository/user_repository.dart';
import '../../../utils/safe_snackbar.dart';
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
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      try {
        final userData = await _userRepo.getUserDetails(email);
        if (userData != null) {
          this.userData.value = userData;
          saveUserDataLocally(userData);
        } else {
          showSnackbarSafely("Error", "User data not found");
        }
      } catch (e) {
        showSnackbarSafely("Error", "Failed to fetch user data: $e");
      }
    } else {
      showSnackbarSafely("Error", "Login to Continue");
    }
  }
}
