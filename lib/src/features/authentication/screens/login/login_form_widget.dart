import 'package:alphabet_green_energy/src/features/authentication/screens/forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text.dart';
import '../../controllers/signin_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    final _formKey = GlobalKey<FormState>();
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: aFormHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: aEmail,
                  hintText: aEmail,
                  border: OutlineInputBorder()),
              validator: (value) => EmailValidator.validate(value!)
                  ? null
                  : "Please enter a valid email",
            ),
            const SizedBox(height: aFormHeight - 20),
            TextFormField(
              controller: controller.password,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.fingerprint),
                labelText: aPassword,
                hintText: aPassword,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye_sharp),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter Password";
                }
                return null;
              },
            ),
            const SizedBox(height: aFormHeight - 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    ForgetPasswordScreen.buildShowModalBottomSheet(context);
                  },
                  child: const Text(aForgetPassword)),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    SignInController.instance.signInUser(
                        controller.email.text.trim(),
                        controller.password.text.trim());
                  }
                },
                child: Text(aLogin.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
