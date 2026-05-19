import 'package:flutter/material.dart';

import '../../theme/tsdtech_colors.dart';

enum CardBrand { visa, mastercard, amex, elo, hipercard, discover, unknown }

CardBrand detectCardBrand(String digits) {
  if (digits.isEmpty) return CardBrand.unknown;

  if (RegExp(r'^3[47]').hasMatch(digits)) return CardBrand.amex;

  if (RegExp(r'^5[1-5]').hasMatch(digits) ||
      RegExp(r'^2(2[2-9][1-9]|[3-6]\d{2}|7[01]\d|720)').hasMatch(digits)) {
    return CardBrand.mastercard;
  }

  if (RegExp(
    r'^(4011|4312|4389|4514|4573|4576|5041|5066|5090|'
    r'6277|6362|6363|6516|6550)',
  ).hasMatch(digits)) {
    return CardBrand.elo;
  }

  if (RegExp(r'^6062').hasMatch(digits)) return CardBrand.hipercard;

  if (RegExp(
    r'^6(011|22(1(2[6-9]|[3-9]\d)|[2-8]\d{2}|9([01]\d|2[0-5]))'
    r'|4[4-9]\d|5\d{2})',
  ).hasMatch(digits)) {
    return CardBrand.discover;
  }

  if (RegExp(r'^4').hasMatch(digits)) return CardBrand.visa;

  return CardBrand.unknown;
}

extension CardBrandX on CardBrand {
  String get label => switch (this) {
    CardBrand.visa => 'VISA',
    CardBrand.mastercard => 'MC',
    CardBrand.amex => 'AMEX',
    CardBrand.elo => 'ELO',
    CardBrand.hipercard => 'HIPER',
    CardBrand.discover => 'DISC',
    CardBrand.unknown => '',
  };

  Color get color => switch (this) {
    CardBrand.visa => const Color(0xFF1A1F71),
    CardBrand.mastercard => const Color(0xFFEB001B),
    CardBrand.amex => const Color(0xFF007BC1),
    CardBrand.elo => const Color(0xFF111111),
    CardBrand.hipercard => const Color(0xFFB12027),
    CardBrand.discover => const Color(0xFFFF6600),
    CardBrand.unknown => TsdtechColors.outlineVariant,
  };
}
