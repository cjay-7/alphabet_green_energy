import 'package:flutter/services.dart';

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    var buffer = StringBuffer();

    // Keep only digits
    for (int i = 0; i < text.length; i++) {
      if (text[i].contains(RegExp(r'[0-9]'))) {
        buffer.write(text[i]);
      }
    }

    var formattedText = buffer.toString();

    if (formattedText.length > 9) {
      // Only take the first 9 digits
      formattedText = formattedText.substring(0, 9);
    }

    // Insert constant prefix
    formattedText = 'AL-V2-24' + formattedText;

    // Add dashes at appropriate places
    if (formattedText.length > 11) {
      formattedText =
          formattedText.substring(0, 11) + '-' + formattedText.substring(11);
    }
    if (formattedText.length > 16) {
      formattedText =
          formattedText.substring(0, 16) + '-' + formattedText.substring(16);
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

// import 'dart:math';
//
// import 'package:flutter/services.dart';
//
// class CustomInputFormatter extends TextInputFormatter {
//   final sampleValue = "AL-V2-24-0000-00000";
//
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final newTextLength = newValue.text.length;
//     final newText = StringBuffer();
//     var selectionIndex = newValue.selection.end;
//
//     return TextEditingValue(
//       text: 'AL-V2-24-$formattedValue',
//       selection:
//       TextSelection.collapsed(offset: 'AL-V2-24-$formattedValue'.length),
//     );

//     if (newTextLength > oldValue.text.length) {
//       //if the entered length exceeds then return old value
//       if (newTextLength > sampleValue.length) {
//         return oldValue;
//       }
//       //check if entered value is digit or not
//       final lastEnteredLetter = newValue.text.substring(newTextLength - 1);
//       if (!RegExp(r'[0-9]').hasMatch(lastEnteredLetter)) {
//         return oldValue;
//       }
//       // If the next index place is a separator, then modify the
//       // text editing value.
//       if (sampleValue.length != newValue.text.length &&
//           sampleValue[newValue.text.length] == '-') {
//         String? modifiedString;
//
//         return TextEditingValue(
//           text: '${modifiedString ?? newValue.text}-',
//           selection:
//           TextSelection.collapsed(offset: newValue.selection.end + 1),
//         );
//       }
//     }
//     // -----
//   }
// }

// import 'package:flutter/services.dart';
//
// class CustomTextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final formattedValue = _formatInput(newValue.text);
//     return TextEditingValue(
//       text: 'AL-V2-24-$formattedValue',
//       selection: TextSelection.collapsed(
//           offset: 'AL-V2-24-$formattedValue'.length),
//     );
//   }
//
//   String _formatInput(String value) {
//     // Remove any non-digit characters
//     final cleanedText = value.replaceAll(RegExp(r'[^0-9]'), '');
//
//     // Limit to 9 digits
//     if (cleanedText.length > 9) {
//       return cleanedText.substring(0, 9);
//     }
//
//     // Insert hyphen after the first 4 digits
//     if (cleanedText.length > 4) {
//       return cleanedText.substring(0, 4) + '-' + cleanedText.substring(4);
//     }
//
//     return cleanedText;
//   }
// }
