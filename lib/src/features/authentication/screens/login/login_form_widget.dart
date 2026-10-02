import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../controllers/signin_controller.dart';
import '../forget_password/forget_password_phone/forget_password_phone.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    var obscurePassword = true.obs;
    var isLoading = false.obs;
    var isGoogleLoading = false.obs;

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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () =>
                      Get.to(() => const ForgetPasswordPhoneScreen()),
                  child: const Text(aForgetPassword)),
            ),
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
            const SizedBox(height: aFormHeight - 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  isGoogleLoading.value = true;
                  try {
                    await AuthenticationRepository.instance.signInWithGoogle();
                  } finally {
                    isGoogleLoading.value = false;
                  }
                },
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: Obx(() {
                  return isGoogleLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(aSignInWithGoogle);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
