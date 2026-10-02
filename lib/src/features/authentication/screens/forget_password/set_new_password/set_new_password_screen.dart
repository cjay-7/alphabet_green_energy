import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text.dart';
import '../../../../../repository/authentication_repository/authentication_repository.dart';
import '../../../../../utils/safe_snackbar.dart';

/// Shown right after a successful phone-recovery sign-in (custom token —
/// see AuthenticationRepository._completePhoneRecovery). No "current
/// password" field: the agent forgot it, that's why they're here, and the
/// fresh custom-token sign-in already satisfies Firebase's recent-login
/// requirement for updatePassword without needing to reauthenticate.
///
/// Deliberately has no back button/Scaffold leading — there's no previous
/// screen in this flow to go back to, only forward (setting a password) or
/// out (logout).
class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await FirebaseAuth.instance.currentUser
          ?.updatePassword(_newPasswordController.text);
      await AuthenticationRepository.instance.completePasswordReset();
      // completePasswordReset() navigates onward (Dashboard/AccountStatus) —
      // nothing left to do here even on success.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showSnackbarSafely("Error", e.message ?? "Couldn't set a new password.");
    } catch (e) {
      if (!mounted) return;
      showSnackbarSafely("Error", "Couldn't set a new password: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(aDefaultSize),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: aDefaultSize * 2),
                    Text(aSetNewPasswordTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.apply(color: aPrimaryColor)),
                    const SizedBox(height: 8),
                    Text(aSetNewPasswordSubTitle,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: aFormHeight),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          label: Text(aNewPassword),
                          prefixIcon: Icon(Icons.lock)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return aNewPasswordRequired;
                        } else if (value.length < 6) {
                          return aPasswordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: aFormHeight - 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          label: Text(aConfirmNewPassword),
                          prefixIcon: Icon(Icons.lock)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return aConfirmPasswordRequired;
                        } else if (value != _newPasswordController.text) {
                          return aPasswordMismatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: aFormHeight),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(aSave),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
