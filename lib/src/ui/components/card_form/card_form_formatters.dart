import 'package:flutter/services.dart';

import 'card_brand.dart';

class CardNumberFormatter extends TextInputFormatter {
  CardNumberFormatter({this.onBrandChanged});

  final void Function(CardBrand brand)? onBrandChanged;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final brand = detectCardBrand(digits);
    onBrandChanged?.call(brand);

    final isAmex = brand == CardBrand.amex;
    final maxLen = isAmex ? 15 : 16;
    final limited = digits.length > maxLen
        ? digits.substring(0, maxLen)
        : digits;

    final buf = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (isAmex) {
        if (i == 4 || i == 10) buf.write(' ');
      } else {
        if (i == 4 || i == 8 || i == 12) buf.write(' ');
      }
      buf.write(limited[i]);
    }

    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 4 ? digits.substring(0, 4) : digits;

    final buf = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 2) buf.write('/');
      buf.write(limited[i]);
    }

    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class TaxIdFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();

    if (digits.length <= 11) {
      final limited = digits.substring(0, digits.length.clamp(0, 11));
      for (int i = 0; i < limited.length; i++) {
        if (i == 3 || i == 6) buf.write('.');
        if (i == 9) buf.write('-');
        buf.write(limited[i]);
      }
    } else {
      final limited = digits.substring(0, digits.length.clamp(0, 14));
      for (int i = 0; i < limited.length; i++) {
        if (i == 2 || i == 5) buf.write('.');
        if (i == 8) buf.write('/');
        if (i == 12) buf.write('-');
        buf.write(limited[i]);
      }
    }

    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
