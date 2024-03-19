import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputFormatter extends TextInputFormatter {
  final String staticPrefix;

  CustomInputFormatter(this.staticPrefix);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Prevent the user from modifying the static prefix
    if (!newValue.text.startsWith(staticPrefix)) {
      // If the newValue doesn't start with the static prefix,
      // we keep the old value
      return oldValue;
    }

    // Offset with a "-" after the 14th character input
    String formattedValue = newValue.text;
    if (formattedValue.length > 14 &&
        !formattedValue.substring(14).contains('-')) {
      formattedValue =
          formattedValue.substring(0, 14) + '-' + formattedValue.substring(14);
    }

    // Limit input after the 18th character
    if (formattedValue.length > 20) {
      // If length exceeds 18 characters, keep the old value
      return oldValue;
    }

    // Return the updated value with the cursor at the end
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
