import 'package:alphabet_green_energy/src/common_widgets/form_header_widget.dart';
import 'package:alphabet_green_energy/src/constants/image_strings.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import "package:flutter/material.dart";
import '../../../../constants/sizes.dart';
import 'login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(aDefaultSize),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                /*------- Section 1 -------*/
                FormHeaderWidget(
                  image: aAlphabetGreensLogo,
                  heightBetween: 20,
                  title: aLoginTitle,
                  subTitle: aLoginSubTitle,
                ),
                /*------- /.end -------*/
                /*------- Section 2 -------*/
                LoginForm(),
                /*------- /.end -------*/
                /*------- Section 3 -------*/
                // LoginFooterWidget(),
                /*------- /.end -------*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
