import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:flutter/material.dart';

class ATextFormFieldTheme {
  ATextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
          border: OutlineInputBorder(),
          prefixIconColor: aSecondaryColor,
          floatingLabelStyle: TextStyle(color: aSecondaryColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: aAccentColor),
          ));

  static InputDecorationTheme darkInputDecorationTheme =
      const InputDecorationTheme(
          border: OutlineInputBorder(),
          prefixIconColor: aPrimaryColor,
          floatingLabelStyle: TextStyle(color: aPrimaryColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: aAccentColor),
          ));
}
