import 'package:flutter/services.dart';

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text
        .toUpperCase()
        .replaceAll('-', ''); // Convert to uppercase and remove dashes

    var buffer = StringBuffer();
    var segmentLengths = [2, 2, 5, 5];

    var currentIndex = 0;

    for (var i = 0;
        i < text.length && currentIndex < segmentLengths.length;
        i++) {
      var currentSegmentLength = segmentLengths[currentIndex];
      var remainingChars = text.length - i;

      var segment = text.substring(
          i,
          i + currentSegmentLength < text.length
              ? i + currentSegmentLength
              : text.length);
      buffer.write(segment);

      if (remainingChars > currentSegmentLength) {
        buffer.write('-');
      }

      i += currentSegmentLength - 1;
      currentIndex++;
    }

    var string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
