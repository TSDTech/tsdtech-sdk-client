import '../../components/card_form/card_form_data.dart';
import 'payment_form_method.dart';

class PaymentFormData {
  const PaymentFormData({
    required this.method,
    this.cardData,
  });

  final PaymentFormMethod method;
  final CardFormData? cardData;

  bool get isCard => method == PaymentFormMethod.card;
  bool get isPix => method == PaymentFormMethod.pix;
}
