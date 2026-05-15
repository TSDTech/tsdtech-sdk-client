import 'package:flutter/material.dart';

enum PaymentFormMethod { pix, card, bill }

extension PaymentFormMethodX on PaymentFormMethod {
  String get label {
    switch (this) {
      case PaymentFormMethod.pix:
        return 'PIX';
      case PaymentFormMethod.card:
        return 'Cartão';
      case PaymentFormMethod.bill:
        return 'Boleto';
    }
  }

  IconData get chipIcon {
    switch (this) {
      case PaymentFormMethod.pix:
        return Icons.qr_code_rounded;
      case PaymentFormMethod.card:
        return Icons.credit_card_rounded;
      case PaymentFormMethod.bill:
        return Icons.receipt_long_rounded;
    }
  }

  IconData get submitIcon {
    switch (this) {
      case PaymentFormMethod.pix:
        return Icons.qr_code_2_rounded;
      case PaymentFormMethod.card:
        return Icons.lock_outline_rounded;
      case PaymentFormMethod.bill:
        return Icons.picture_as_pdf_outlined;
    }
  }
}
