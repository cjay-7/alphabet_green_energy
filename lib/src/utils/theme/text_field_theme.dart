import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:flutter/material.dart';

import 'text_theme.dart';

class ATextFormFieldTheme {
  ATextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
      border: const OutlineInputBorder(),
      hintStyle: AppTextTheme.lightTextTheme.bodySmall,
      prefixIconColor: aSecondaryColor,
      floatingLabelStyle: const TextStyle(color: aSecondaryColor),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: aAccentColor),
      ));

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
      border: const OutlineInputBorder(),
      hintStyle: AppTextTheme.darkTextTheme.bodySmall,
      prefixIconColor: aPrimaryColor,
      floatingLabelStyle: const TextStyle(color: aPrimaryColor),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: aAccentColor),
      ));
}
