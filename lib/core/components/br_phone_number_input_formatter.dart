import 'package:flutter/services.dart';

class BrPhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 11) digits = digits.substring(0, 11);

    String formatted = '';
    if (digits.isNotEmpty) {
      formatted += '(';
      formatted += digits.substring(0, digits.length >= 2 ? 2 : digits.length);
    }
    if (digits.length > 2) {
      formatted += ') ';
      formatted += digits.substring(2, digits.length >= 7 ? 7 : digits.length);
    }
    if (digits.length > 7) {
      formatted += '-';
      formatted += digits.substring(7, digits.length);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
