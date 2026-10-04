import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/authentication/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpController = Get.put(OTPController());

    const boxTheme = PinTheme(
      width: 48,
      height: 64,
      textStyle: TextStyle(
          color: aPrimaryColor, fontSize: 28, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: aPrimaryColor, width: 2)),
      ),
    );
    final focusedBoxTheme = boxTheme.copyDecorationWith(
      border: const Border(bottom: BorderSide(color: aAccentColor, width: 2)),
    );

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
            // Switched from flutter_otp_text_field to pinput: the former
            // builds one real TextFormField per digit box kept in sync by
            // hand, which is what caused the invisible-text and
            // input-leaking-across-boxes bugs found on the phone-number
            // field (same package). pinput renders every box from a single
            // underlying TextEditingController, so there's no per-box
            // state to go out of sync.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Pinput(
                length: 6,
                controller: _otpController,
                defaultPinTheme: boxTheme,
                focusedPinTheme: focusedBoxTheme,
                submittedPinTheme: boxTheme,
                separatorBuilder: (index) => const SizedBox(width: 6),
                onCompleted: otpController.verifyOTP,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
