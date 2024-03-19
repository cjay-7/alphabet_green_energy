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
    var obscurePassword = true.obs;
    var isLoading = false.obs;

    void togglePasswordVisibility() {
      obscurePassword.value = !obscurePassword.value;
    }

    final formKey = GlobalKey<FormState>();

    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: formKey,
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
            Obx(
              () => TextFormField(
                controller: controller.password,
                obscureText: obscurePassword.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.fingerprint),
                  labelText: aPassword,
                  hintText: aPassword,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () => togglePasswordVisibility(),
                    icon: Icon(obscurePassword.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Password";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: aFormHeight - 20),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: TextButton(
            //       onPressed: () {
            //         ForgetPasswordScreen.buildShowModalBottomSheet(context);
            //       },
            //       child: const Text(aForgetPassword)),
            // ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      isLoading.value = true;
                      await SignInController.instance.signInUser(
                        controller.email.text.trim(),
                        controller.password.text.trim(),
                      );
                    } finally {
                      isLoading.value = false;
                    }
                  }
                },
                child: Obx(() {
                  return isLoading.value
                      ? const CircularProgressIndicator()
                      : Text(aLogin.toUpperCase());
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
