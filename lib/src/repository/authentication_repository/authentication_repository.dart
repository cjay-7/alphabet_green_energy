import 'package:alphabet_green_energy/src/constants/firestore_keys.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/account_status/account_status_screen.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/login/login_screen.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/signup/signup_success_screen.dart';
import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/safe_snackbar.dart';
import '../user_repository/user_repository.dart';
import 'exceptions/signup_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  Future<void> _setInitialScreen(User? user) async {
    if (kIsWeb) {
      // The web build is a self-service signup kiosk with no Dashboard to
      // land on — route signed-out visitors to the form, and anyone who
      // just signed up (or still has a session) to a confirmation screen
      // instead of silently bouncing them back to the same empty form.
      user == null
          ? Get.offAll(() => const SignUpScreen())
          : Get.offAll(() => const SignUpSuccessScreen());
      return;
    }

    if (user == null) {
      Get.offAll(() => const LoginScreen());
      return;
    }

    // Native app: every agent now needs an admin to approve their signup
    // (notifyAdminsOnSignup Cloud Function emails the Approve/Deny link)
    // before they get past a pending/denied holding screen into the
    // Dashboard. Read straight from Firestore rather than UserRepository's
    // cached copy, since this check has to reflect the live approval state.
    try {
      final doc = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .get();
      final status =
          doc.data()?[UserFields.approvalStatus] as String? ??
              ApprovalStatus.pending;
      status == ApprovalStatus.approved
          ? Get.offAll(() => const Dashboard())
          : Get.offAll(() => const AccountStatusScreen());
    } catch (e) {
      // Can't confirm approval — fail closed, not into the Dashboard.
      Get.offAll(() => const AccountStatusScreen());
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, UserModel agent) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await UserRepository.instance.createUser(agent, uid);
      } else {
        Get.to(() => const SignUpScreen());
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print(
          "FIREBASE AUTH EXCEPTION in createUserWithEmailAndPassword: code=${e.code}, message=${e.message}");
      throw ex;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print("EXCEPTION in createUserWithEmailAndPassword: $e");
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
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
      } else {
        print(
            "FIREBASE AUTH EXCEPTION in loginWithEmailAndPassword: ${e.code} - ${e.message}");
        _showLoginErrorSnackBar(e.message ?? "Login failed (${e.code})");
      }
    } catch (e) {
      print("Error in loginWithEmailAndPassword: $e");
      _showLoginErrorSnackBar("Login failed: $e");
    }
  }

  void _showLoginErrorSnackBar(String message) {
    final context = Get.context;
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent.withOpacity(.3),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  Future<void> logout() async => await _auth.signOut();

  /// Re-authenticates with [currentPassword] before setting [newPassword],
  /// since Firebase Auth requires a recent sign-in to change a password.
  /// Throws [FirebaseAuthException] on failure (e.g. code 'wrong-password'/
  /// 'invalid-credential' if currentPassword doesn't match).
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw FirebaseAuthException(
          code: 'no-current-user', message: 'You are not logged in.');
    }
    final credential =
        EmailAuthProvider.credential(email: email, password: currentPassword);
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          showSnackbarSafely(
              'Error', 'The provided phone number is not valid.');
        } else {
          showSnackbarSafely('Error', 'Something went wrong. Try again.');
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
