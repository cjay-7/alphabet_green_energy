import "package:alphabet_green_energy/src/utils/theme/outline_button_theme.dart";
import "package:alphabet_green_energy/src/utils/theme/text_field_theme.dart";
import "package:alphabet_green_energy/src/utils/theme/text_theme.dart";
import "package:flutter/material.dart";

import "elevated_button_theme.dart";

class AppTheme {
  AppTheme._();
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: const MaterialColor(0xFF262626, <int, Color>{
      50: Color(0xFFE5E5E5),
      100: Color(0xFFBEBEBE),
      200: Color(0xFF939393),
      300: Color(0xFF676767),
      400: Color(0xFF474747),
      500: Color(0xFF262626),
      600: Color(0xFF222222),
      700: Color(0xFF1C1C1C),
      800: Color(0xFF171717),
      900: Color(0xFF0D0D0D),
    }),
    textTheme: AppTextTheme.lightTextTheme,
    elevatedButtonTheme: AElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: AOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: ATextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: AppTextTheme.darkTextTheme,
    elevatedButtonTheme: AElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: AOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: ATextFormFieldTheme.darkInputDecorationTheme,
  );
}
