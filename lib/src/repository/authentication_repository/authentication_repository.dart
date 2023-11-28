import 'package:alphabet_green_energy/src/features/authentication/screens/login/login_screen.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../user_repository/user_repository.dart';
import 'exceptions/signup_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 6));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (kIsWeb) {
      Get.offAll(() =>
          const SignUpScreen()); // Redirect to SignUpScreen for web platform
    } else {
      user == null
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const Dashboard());
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, UserModel agent) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() async {
              await UserRepository.instance.createUser(agent);
              const Center(
                child: Text(
                  "Account Successfully created.",
                  style: TextStyle(
                      color: Colors.white70, decoration: TextDecoration.none),
                ),
              );
            })
          : Get.to(() => const SignUpScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print("FIREBASE AUTH EXCEPTION - ${ex.message}");
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print("EXCEPTION -${ex.message}");
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() async {
              const Dashboard();
            })
          : Get.to(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        var snackBar = SnackBar(
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Incorrect Password",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent.withOpacity(.3),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.fixed,
        );
        ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
      } else if (e.code == "user-not-found") {
        var snackBar = SnackBar(
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  "User Not Found",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent.withOpacity(.3),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.fixed,
        );
        ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
      } else if (e.code == "network-request-failed") {
        var snackBar = SnackBar(
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Network error",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent.withOpacity(.3),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.fixed,
        );
        ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
      }
    } catch (e) {
      print("Error in loginWithEmailAndPassword: $e");
    }
  }

  Future<void> logout() async => await _auth.signOut();

  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('Error', 'The provided phone number is not valid.');
        } else {
          Get.snackbar('Error', 'Something went wrong. Try again.');
        }
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }
}
