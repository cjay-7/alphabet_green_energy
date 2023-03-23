import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/sizes.dart';
import '../../../../../constants/text.dart';
import '../forget_password_mail/forget_password_mail.dart';
import '../forget_password_phone/forget_password_phone.dart';
import 'forget_password_btn_widget.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        builder: (context) => Container(
              padding: const EdgeInsets.all(aDefaultSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(aForgetPasswordTitle,
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text(aForgetPasswordSubTitle,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 20.0),
                  ForgetPasswordBtnWidget(
                      btnIcon: Icons.mail_outline_rounded,
                      title: aEmail,
                      subTitle: aResetViaEMail,
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const ForgetPasswordMailScreen());
                      }),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ForgetPasswordBtnWidget(
                    btnIcon: Icons.mobile_friendly_rounded,
                    title: aPhoneNo,
                    subTitle: aResetViaEMail,
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const ForgetPasswordPhoneScreen());
                    },
                  ),
                ],
              ),
            ));
  }
}
