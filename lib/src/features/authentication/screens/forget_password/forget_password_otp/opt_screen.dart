import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/authentication/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final otpController = Get.put(OTPController());
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(aDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              aOtpTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 40.0),
            OtpTextField(
              numberOfFields: 6,
              // OtpTextField's own default text style doesn't pick up this
              // app's dark theme — confirmed live, typed digits were
              // invisible (black-on-black) against the box.
              textStyle: const TextStyle(color: aPrimaryColor, fontSize: 18),
              cursorColor: aAccentColor,
              enabledBorderColor: aPrimaryColor,
              focusedBorderColor: aAccentColor,
              showFieldAsBox: true,
              onSubmit: otpController.verifyOTP,
            ),
          ],
        ),
      ),
    );
  }
}
