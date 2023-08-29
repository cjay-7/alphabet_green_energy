import 'package:alphabet_green_energy/firebase_options.dart';
import 'package:alphabet_green_energy/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:alphabet_green_energy/src/repository/authentication_repository/authentication_repository.dart';
import 'package:alphabet_green_energy/src/repository/user_repository/user_repository.dart';
import 'package:alphabet_green_energy/src/utils/theme/theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/features/authentication/screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LfnxMYnAAAAAEC4-zKNzlUaBYGCE6sa_l_dk-TN',
    androidProvider: AndroidProvider.debug,
  );
  Get.put(AuthenticationRepository());
  Get.put(UserRepository());
  if (kIsWeb) {
    // Use a different home screen for the web platform
    runApp(const WebHomeScreen());
  } else {
    runApp(const App());
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      home: const LoginScreen(),
    );
  }
}

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      home: const SignUpScreen(),
    );
  }
}
