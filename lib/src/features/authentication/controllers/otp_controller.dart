import 'package:alphabet_green_energy/src/repository/authentication_repository/authentication_repository.dart';
import 'package:get/get.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  void verifyOTP(String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    // Don't navigate to Dashboard directly on success — that would skip the
    // admin-approval check. AuthenticationRepository's firebaseUser listener
    // (ever(firebaseUser, _setInitialScreen)) already fires on this sign-in
    // and routes to Dashboard/AccountStatusScreen/LoginScreen correctly, the
    // same way email/password login and signup do.
    if (!isVerified) Get.back();
  }
}
