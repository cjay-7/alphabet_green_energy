import 'package:alphabet_green_energy/src/common_widgets/form_header_widget.dart';
import 'package:alphabet_green_energy/src/common_widgets/phone_number_field.dart';
import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/image_strings.dart';
import '../../../../repository/authentication_repository/exceptions/signup_exceptions.dart';
import '../../../../utils/safe_snackbar.dart';
import '../../controllers/signup_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final controller = Get.put(SignUpController());
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;
  String _phoneNo = '';

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final agent = UserModel(
      email: controller.email.text.removeAllWhitespace,
      phoneNo: _phoneNo,
      fullName: controller.name.text.removeAllWhitespace,
    );

    try {
      await SignUpController.instance.registerUser(
        controller.email.text.trim(),
        controller.password.text.trim(),
        agent,
      );
      // On success, AuthenticationRepository's auth-state listener
      // navigates to SignUpSuccessScreen on its own — nothing else to do.
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      if (!mounted) return;
      showSnackbarSafely("Error", e.message);
    } catch (e) {
      if (!mounted) return;
      showSnackbarSafely("Error", "Something went wrong: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;

    double horizontalPadding = 0;
    if (screenSize > 599) {
      horizontalPadding = 200;
    } else if (screenSize > 399) {
      horizontalPadding = 100;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(aDefaultSize),
          child: Column(
            children: [
              const FormHeaderWidget(
                  image: aAlphabetGreensLogo,
                  title: aSignUpTitle,
                  subTitle: aSignUpSubTitle),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: aFormHeight - 10, horizontal: horizontalPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controller.name,
                          decoration: const InputDecoration(
                            label: Text(aFullName),
                            prefixIcon: Icon(Icons.person_2_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return aFullNameRequired;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controller.email,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: aEmail,
                              hintText: aEmail,
                              border: OutlineInputBorder()),
                          validator: (value) => EmailValidator.validate(value!)
                              ? null
                              : aValidEmailRequired,
                        ),
                      ),
                      const SizedBox(height: aFormHeight - 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controller.password,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.fingerprint),
                            labelText: aPassword,
                            hintText: aPassword,
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return aPasswordRequired;
                            } else if (value.length < 6) {
                              return aPasswordTooShort;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.fingerprint),
                            labelText: aConfirmPassword,
                            hintText: aConfirmPassword,
                            suffixIcon: IconButton(
                              onPressed: () => setState(() =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword),
                              icon: Icon(_obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return aPleaseConfirmPassword;
                            } else if (value != controller.password.text) {
                              return aPasswordMismatch;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PhoneNumberField(
                          onChanged: (value) => _phoneNo = value,
                          validator: validatePhoneNumber,
                        ),
                      ),
                      const SizedBox(height: aFormHeight - 20),
                      SizedBox(
                        width: double.infinity,
                        height: aFormHeight * 2,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(aSignUp.toUpperCase()),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
