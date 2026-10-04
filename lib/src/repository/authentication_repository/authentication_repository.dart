import 'dart:convert';

import 'package:alphabet_green_energy/src/constants/cloud_functions.dart';
import 'package:alphabet_green_energy/src/constants/firestore_keys.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/account_status/account_status_screen.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/login/login_screen.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/forget_password/set_new_password/set_new_password_screen.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/signup/signup_success_screen.dart';
import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../utils/safe_snackbar.dart';
import '../user_repository/user_repository.dart';
import 'exceptions/signup_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  // Set right before signInWithCustomToken in a phone-recovery exchange, so
  // _setInitialScreen routes to SetNewPasswordScreen for that one sign-in
  // instead of the normal approval-status gate. A custom-token sign-in still
  // needs a new password set before the agent is usably "back in".
  bool _pendingPasswordReset = false;

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

    if (_pendingPasswordReset) {
      Get.offAll(() => const SetNewPasswordScreen());
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

  Future<void> logout() async {
    await _auth.signOut();
    // Best-effort: clears the cached Google session too, so logging back in
    // (possibly as a different agent) shows the account picker again instead
    // of silently reusing whichever Google account was signed in last. Not
    // every session got here via Google, so failures here are expected/fine.
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }

  /// Signs in with Google, but — deliberately — can never be used to create
  /// a new agent account. Signup only happens through the web kiosk, gated
  /// by admin approval; if Google sign-in could create accounts too, that
  /// gate would be trivially bypassable by anyone with a Google account. If
  /// Firebase reports this as a brand-new Auth user (no existing agent
  /// behind this Google account), the just-created account is deleted and
  /// the sign-in is rejected instead of silently granting access.
  Future<void> signInWithGoogle() async {
    try {
      final googleAccount = await GoogleSignIn.instance.authenticate();
      final idToken = googleAccount.authentication.idToken;
      if (idToken == null) {
        showSnackbarSafely(
            "Error", "Google didn't return a valid token. Try again.");
        return;
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await userCredential.user?.delete();
        await GoogleSignIn.instance.signOut();
        showSnackbarSafely("Error",
            "No existing agent account for this Google account. Sign up first and wait for admin approval.");
        return;
      }
      // Existing account — ever(firebaseUser, _setInitialScreen) handles
      // navigation (including the approval-status check) from here.
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return;
      showSnackbarSafely(
          "Error", "Google sign-in failed: ${e.description ?? e.code}");
    } on FirebaseAuthException catch (e) {
      showSnackbarSafely("Error", e.message ?? "Google sign-in failed.");
    } catch (e) {
      showSnackbarSafely("Error", "Google sign-in failed: $e");
    }
  }

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

  /// Step 1 of phone-based account recovery ("forgot password"): sends an
  /// OTP to [phoneNumber] (already a full E.164 string, e.g.
  /// "+919876543210" — PhoneNumberField's country-code picker produces this
  /// directly, so there's no single hardcoded country to assume here).
  /// This can never create a new agent account; see
  /// verifyOTP/_completePhoneRecovery for why.
  Future<void> phoneAuthentication(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        await _completePhoneRecovery(credential);
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

  /// Step 2: verifies [otp], then exchanges it (via the recoverAccountByPhone
  /// Cloud Function) for a sign-in to whichever EXISTING agent's signup
  /// phone number matches — never a new account created from a phone number
  /// alone. Returns false (with an error snackbar already shown) on failure.
  Future<bool> verifyOTP(String otp) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value, smsCode: otp);
    return _completePhoneRecovery(credential);
  }

  /// Firebase's phone sign-in has no concept of "verify this number against
  /// an existing email/password account" — signing in with a phone
  /// credential either finds an account that previously *linked* that
  /// phone number as an Auth provider, or creates a brand-new one. Since no
  /// agent here does that linking step, this almost always creates an
  /// ephemeral, otherwise-useless phone-only account.
  ///
  /// So instead: sign in with it anyway (this is just OTP verification,
  /// Firebase has no lower-level "verify without signing in" primitive),
  /// send that ephemeral session's ID token to recoverAccountByPhone, which
  /// looks up the agent whose *signup-time* Phone field matches, mints a
  /// custom token for THEIR uid, and deletes the ephemeral user server-side.
  /// Signing in with that custom token replaces the ephemeral session with
  /// the agent's real one.
  Future<bool> _completePhoneRecovery(PhoneAuthCredential credential) async {
    try {
      final ephemeralCredential = await _auth.signInWithCredential(credential);
      final idToken = await ephemeralCredential.user?.getIdToken();
      if (idToken == null) {
        throw Exception("Phone verification didn't return a session.");
      }

      final response = await http.post(
        Uri.parse('$kFunctionsBaseUrl/recoverAccountByPhone'),
        headers: {'Authorization': 'Bearer $idToken'},
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        throw Exception(body['error'] as String? ??
            'No agent account found for this phone number.');
      }

      _pendingPasswordReset = true;
      await _auth.signInWithCustomToken(body['customToken'] as String);
      return true;
    } catch (e) {
      showSnackbarSafely('Error', 'Could not verify phone: $e');
      return false;
    }
  }

  /// Called by SetNewPasswordScreen once the agent has set a new password
  /// after a phone-recovery sign-in. Clears the one-shot redirect flag and
  /// re-runs the normal screen routing (approval-status gate, etc.) for the
  /// now-current user.
  Future<void> completePasswordReset() async {
    _pendingPasswordReset = false;
    await _setInitialScreen(_auth.currentUser);
  }
}
