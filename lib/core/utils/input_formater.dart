import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumericTextInputFormatter5 extends TextInputFormatter {
  NumericTextInputFormatter5({this.maxDecimals = 2});
  // Set to null for unlimited decimals
  final int? maxDecimals;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow empty input or just a single "0"
    if (newValue.text.isEmpty || newValue.text == "0") {
      return newValue;
    }

    // Remove all commas from the input to work with plain numbers
    String raw = newValue.text.replaceAll(',', '');

    // Build regex: digits, optional '.', then up to maxDecimals digits
    final RegExp decimalRegExp = maxDecimals == null
        ? RegExp(r'^\d*\.?\d*$')
        : RegExp(r'^\d*\.?\d{0,' + maxDecimals!.toString() + r'}$');

    if (!decimalRegExp.hasMatch(raw)) {
      return oldValue;
    }

    // Split integer/decimal parts
    final parts = raw.split('.');
    final String intPartStr = parts[0].isEmpty ? '0' : parts[0];
    String formattedInt = NumberFormat("#,##0").format(
      double.parse(intPartStr),
    );

    // Re-attach decimal part (truncate if above maxDecimals)
    if (parts.length > 1) {
      String dec = parts[1];
      if (maxDecimals != null && dec.length > maxDecimals!) {
        dec = dec.substring(0, maxDecimals);
      }
      formattedInt += '.$dec';
    }

    return newValue.copyWith(
      text: formattedInt,
      selection: TextSelection.collapsed(offset: formattedInt.length),
    );
  }
}



class NumericTextInputFormatter3 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow empty input or just a single "0"
    if (newValue.text.isEmpty || newValue.text == "0") {
      return newValue;
    }

    // Remove all commas from the input to work with plain numbers
    String newText = newValue.text.replaceAll(',', '');

    // Regular expression to match valid numeric input with up to two decimal places
    final RegExp decimalRegExp = RegExp(r'^\d*\.?\d{0,2}$');

    // Check if the new value matches the regex
    if (decimalRegExp.hasMatch(newText)) {
      // Handle decimal part separately to maintain the precision
      List<String> parts = newText.split('.');
      String formatted = NumberFormat("#,##0").format(
        double.parse(parts[0]),
      );

      // Add the decimal part back if it exists
      if (parts.length > 1) {
        formatted += '.${parts[1]}';
      }

      // Create a new TextEditingValue with the formatted text
      return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    } else {
      // If the new value contains invalid input, return the old value
      return oldValue;
    }
  }
}

// // class NumericTextInputFormatter2 extends TextInputFormatter {
// //   @override
// //   TextEditingValue formatEditUpdate(
// //       TextEditingValue oldValue, TextEditingValue newValue) {
// //     // Regular expression to match digits and an optional decimal point with digits after it
// //     final RegExp decimalRegExp = RegExp(r'^\d*\.?\d*$');

// //     // Check if the new value matches the regex
// //     if (decimalRegExp.hasMatch(newValue.text)) {
// //       return newValue;
// //     } else {
// //       // If the new value contains non-numeric characters or invalid decimal, return the old value
// //       return oldValue;
// //     }
// //   }
// // }

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Regular expression to match only digits and one decimal point
    final RegExp numericRegExp = RegExp(r'^\d*\.?\d*$');

    // Check if the new value matches the regex
    if (numericRegExp.hasMatch(newValue.text)) {
      return newValue;
    } else {
      // If the new value contains invalid characters, return the old value
      return oldValue;
    }
  }
}
