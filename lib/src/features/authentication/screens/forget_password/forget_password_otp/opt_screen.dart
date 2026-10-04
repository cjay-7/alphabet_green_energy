import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/authentication/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              // OtpTextField sets maxLength on each box to numberOfFields
              // rather than 1, relying entirely on its own onChanged logic
              // to redistribute any multi-character input as a "paste" —
              // confirmed on the phone-number field (same package) that an
              // IME quirk can deliver more than one character to a single
              // box, stamping that value across every other box too.
              // Enforcing a hard 1-character limit here stops that.
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              onSubmit: otpController.verifyOTP,
            ),
          ],
        ),
      ),
    );
  }
}
