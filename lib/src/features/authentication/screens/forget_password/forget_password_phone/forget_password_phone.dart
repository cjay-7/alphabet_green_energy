import 'package:alphabet_green_energy/src/common_widgets/form_header_widget.dart';
import 'package:alphabet_green_energy/src/common_widgets/phone_number_field.dart';
import 'package:alphabet_green_energy/src/constants/image_strings.dart';
import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/forget_password/forget_password_otp/opt_screen.dart';
import 'package:alphabet_green_energy/src/repository/authentication_repository/authentication_repository.dart';
import 'package:alphabet_green_energy/src/utils/safe_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordPhoneScreen extends StatefulWidget {
  const ForgetPasswordPhoneScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPhoneScreen> createState() =>
      _ForgetPasswordPhoneScreenState();
}

class _ForgetPasswordPhoneScreenState
    extends State<ForgetPasswordPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  String _phoneNo = '';
  bool _isSending = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);
    try {
      await AuthenticationRepository.instance.phoneAuthentication(_phoneNo);
      if (!mounted) return;
      Get.to(() => const OTPScreen());
    } catch (e) {
      if (!mounted) return;
      showSnackbarSafely("Error", "Couldn't send OTP: $e");
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(aDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: aDefaultSize * 4),
                const FormHeaderWidget(
                  image: aForgetPasswordImage,
                  title: aForgetPassword,
                  subTitle: aForgetPhoneSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: aFormHeight),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      PhoneNumberField(
                        onChanged: (value) => _phoneNo = value,
                        validator: validatePhoneNumber,
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSending ? null : _submit,
                          child: _isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : const Text(aNext),
                        ),
                      ),
                    ],
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
