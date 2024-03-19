import 'package:alphabet_green_energy/src/common_widgets/form_header_widget.dart';
import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/image_strings.dart';
import '../../controllers/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    var obscurePassword = true.obs; // Using RxBool for GetX state management
    void togglePasswordVisibility() {
      obscurePassword.value = !obscurePassword.value;
    }

    final formKey = GlobalKey<FormState>();
    var screenSize = MediaQuery.of(context).size.width;

    print(screenSize);
    double horizontalPadding = 0;
    if (screenSize > 399) {
      horizontalPadding = 100;
    } else if (screenSize > 599) {
      horizontalPadding = 200;
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
                  key: formKey,
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
                              : "Please enter a valid email",
                        ),
                      ),
                      const SizedBox(height: aFormHeight - 20),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controller.phoneNo,
                          decoration: InputDecoration(
                              labelText: aPhoneNo,
                              prefixIcon: const Icon(Icons.phone),
                              hintText: aPhoneNo,
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                              border: const OutlineInputBorder()),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter Phone Number";
                            } else if (int.tryParse(value) == null) {
                              return 'Only numbers are allowed';
                            } else if (value.length != 10) {
                              return "Please enter valid Number";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: aFormHeight - 20),
                      SizedBox(
                        width: double.infinity,
                        height: aFormHeight * 2,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final agent = UserModel(
                                  email:
                                      controller.email.text.removeAllWhitespace,
                                  password: controller
                                      .password.text.removeAllWhitespace,
                                  phoneNo: controller
                                      .phoneNo.text.removeAllWhitespace,
                                  fullName:
                                      controller.name.text.removeAllWhitespace);
                              SignUpController.instance.registerUser(
                                  controller.email.text.trim(),
                                  controller.password.text.trim(),
                                  agent);
                            }
                          },
                          child: Text(aSignUp.toUpperCase()),
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
