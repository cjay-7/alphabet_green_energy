import 'package:alphabet_green_energy/src/common_widgets/form_header_widget.dart';
import 'package:alphabet_green_energy/src/constants/image_strings.dart';
import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/forget_password/forget_pasword_otp/opt_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

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
                  subTitle: aForgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: aFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text(aEmail),
                            hintText: aEmail,
                            prefixIcon: Icon(Icons.mail_outline_rounded)),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => const OTPScreen());
                              },
                              child: const Text(aNext)))
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
