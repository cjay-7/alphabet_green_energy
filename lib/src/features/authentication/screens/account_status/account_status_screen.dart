import 'dart:convert';

import 'package:alphabet_green_energy/src/constants/firestore_keys.dart';
import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/dashboard.dart';
import 'package:alphabet_green_energy/src/repository/authentication_repository/authentication_repository.dart';
import 'package:alphabet_green_energy/src/utils/safe_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// Cloud Functions base URL for this project/region — same project as
/// firebase_options.dart, same region as functions/index.js's functions.
const String _kFunctionsBaseUrl =
    'https://asia-south1-alphabetgreens.cloudfunctions.net';

/// Shown instead of the Dashboard while an agent's account is "pending" or
/// "denied". Streams the Users doc directly (rather than a one-off fetch) so
/// an agent sitting on this screen is moved to the Dashboard the moment an
/// admin approves them from the email link, with no app restart needed.
class AccountStatusScreen extends StatefulWidget {
  const AccountStatusScreen({super.key});

  @override
  State<AccountStatusScreen> createState() => _AccountStatusScreenState();
}

class _AccountStatusScreenState extends State<AccountStatusScreen> {
  bool _isResending = false;

  Future<void> _resendApprovalEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isResending = true);
    try {
      final idToken = await user.getIdToken();
      final response = await http.post(
        Uri.parse('$_kFunctionsBaseUrl/resendApprovalEmail'),
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        showSnackbarSafely("Success", aResendApprovalEmailSuccess);
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        showSnackbarSafely(
            "Error", body['error'] as String? ?? "Something went wrong.");
      }
    } catch (e) {
      if (!mounted) return;
      showSnackbarSafely("Error", "Couldn't reach the server: $e");
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = AuthenticationRepository.instance.firebaseUser.value?.uid;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(aDefaultSize),
            child: uid == null
                ? OutlinedButton(
                    onPressed: () => AuthenticationRepository.instance.logout(),
                    child: const Text(aLogoutDialogHeading),
                  )
                : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection(FirestoreCollections.users)
                        .doc(uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final status =
                          snapshot.data?.data()?[UserFields.approvalStatus]
                                  as String? ??
                              ApprovalStatus.pending;

                      if (status == ApprovalStatus.approved) {
                        WidgetsBinding.instance.addPostFrameCallback(
                            (_) => Get.offAll(() => const Dashboard()));
                      }

                      final isDenied = status == ApprovalStatus.denied;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isDenied
                                ? Icons.block
                                : Icons.hourglass_top_rounded,
                            size: 72,
                            color: isDenied ? Colors.red : Colors.orange,
                          ),
                          const SizedBox(height: aFormHeight),
                          Text(
                            isDenied
                                ? aAccountDeniedTitle
                                : aAccountPendingTitle,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isDenied
                                ? aAccountDeniedMessage
                                : aAccountPendingMessage,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: aFormHeight),
                          if (!isDenied)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: OutlinedButton(
                                onPressed:
                                    _isResending ? null : _resendApprovalEmail,
                                child: _isResending
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Text(aResendApprovalEmail),
                              ),
                            ),
                          OutlinedButton(
                            onPressed: () =>
                                AuthenticationRepository.instance.logout(),
                            child: const Text(aLogoutDialogHeading),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
