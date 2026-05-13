class CardPaymentData {
  final String cardNumber;
  final String cardHolderName;
  final String expirationMonth;
  final String expirationYear;
  final String cvv;

  CardPaymentData({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expirationMonth,
    required this.expirationYear,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expirationMonth': expirationMonth,
      'expirationYear': expirationYear,
      'cvv': cvv,
    };
  }
}

class CardEncryptor {
  static String encrypt(CardPaymentData cardData, String pemPublicKey) {
    return 'encrypted_payload_mock';
  }
}
