import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../../../utils/safe_snackbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await AuthenticationRepository.instance.changePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );
      if (!mounted) return;
      showSnackbarSafely("Success", aPasswordUpdated,
          backgroundColor: aSuccessColor.withOpacity(0.1),
          colorText: aSuccessColor);
      Get.back();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final message =
          (e.code == 'wrong-password' || e.code == 'invalid-credential')
              ? aIncorrectCurrentPassword
              : (e.message ?? aIncorrectCurrentPassword);
      showSnackbarSafely("Error", message);
    } catch (e) {
      if (!mounted) return;
      showSnackbarSafely("Error", "Failed to update password: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
        title: Text(aChangePassword,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.apply(color: aPrimaryColor)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(aDefaultSize),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      label: Text(aCurrentPassword),
                      prefixIcon: Icon(Icons.lock_outline)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return aCurrentPasswordRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: aFormHeight - 20),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      label: Text(aNewPassword), prefixIcon: Icon(Icons.lock)),
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
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(aSave),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
