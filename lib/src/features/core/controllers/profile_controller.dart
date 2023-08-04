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

  // Method to save user data locally
  saveUserDataLocally(UserModel userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJsonString = userData.toJsonString();
    prefs.setString('user_data', userDataJsonString);
  }

  Future<void> getUserData() async {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      final userData = await _userRepo.getUserDetails(email);
      this.userData.value = userData; // Set the value of the reactive variable
      saveUserDataLocally(userData);
    } else {
      Get.snackbar("Error", "Login to Continue");
    }
  }
}
