import 'package:flutter/material.dart';

enum PaymentFormMethod { pix, card }

extension PaymentFormMethodX on PaymentFormMethod {
  String get label {
    switch (this) {
      case PaymentFormMethod.pix:
        return 'PIX';
      case PaymentFormMethod.card:
        return 'Cartão';
    }
  }

  IconData get chipIcon {
    switch (this) {
      case PaymentFormMethod.pix:
        return Icons.qr_code_rounded;
      case PaymentFormMethod.card:
        return Icons.credit_card_rounded;
    }
  }

  IconData get submitIcon {
    switch (this) {
      case PaymentFormMethod.pix:
        return Icons.qr_code_2_rounded;
      case PaymentFormMethod.card:
        return Icons.lock_outline_rounded;
    }
  }
}
