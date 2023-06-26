import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:flutter/material.dart';

class AElevatedButtonTheme {
  AElevatedButtonTheme._();

  /* -- Light Theme -- */

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: aDarkColor,
      backgroundColor: aAccentColor,
      side: const BorderSide(color: aAccentColor),
      padding: const EdgeInsets.symmetric(vertical: aButtonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
  );

  /* -- Dark Theme -- */

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: aSecondaryColor,
      backgroundColor: aAccentColor,
      side: const BorderSide(color: aSecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: aButtonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
  );
}
