import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';

/// Shown after a successful web signup. The web build has no Dashboard to
/// land on (see AuthenticationRepository._setInitialScreen), so without
/// this screen a successful signup had nowhere to go except straight back
/// to the same empty signup form — no confirmation a new agent could see
/// their registration actually worked.
class SignUpSuccessScreen extends StatelessWidget {
  const SignUpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(aDefaultSize),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: const AssetImage(aAlphabetGreensLogo),
                  width: 80,
                ),
                const SizedBox(height: 24),
                Icon(Icons.check_circle, color: aAccentColor, size: 64),
                const SizedBox(height: 16),
                Text(
                  aSignUpSuccessTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  aSignUpSuccessMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: aFormHeight),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => AuthenticationRepository.instance.logout(),
                    child: const Text(aSignUpAnother),
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
