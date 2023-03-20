import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:flutter/material.dart';

class AOutlinedButtonTheme {
  AOutlinedButtonTheme._();

  /* -- Light Theme -- */

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: aSecondaryColor,
      backgroundColor: aPrimaryColor,
      side: const BorderSide(color: aSecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: aButtonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
  );

  /* -- Dark Theme -- */

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: aPrimaryColor,
      backgroundColor: aSecondaryColor,
      side: const BorderSide(color: aAccentColor),
      padding: const EdgeInsets.symmetric(vertical: aButtonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
  );
}
