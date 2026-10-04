import 'package:alphabet_green_energy/src/common_widgets/digit_boxes_field.dart';
import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/authentication/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DigitBoxesField(
                length: 6,
                controller: _otpController,
                boxWidth: 48,
                boxHeight: 64,
                fontSize: 28,
                onChanged: (_) {},
                onCompleted: otpController.verifyOTP,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
