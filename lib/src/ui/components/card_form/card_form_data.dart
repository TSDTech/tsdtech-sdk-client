import 'card_brand.dart';

class CardFormData {
  const CardFormData({
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryDate,
    required this.cvv,
    required this.taxId,
    required this.brand,
  });

  final String cardNumber;
  final String cardholderName;
  final String expiryDate;
  final String cvv;
  final String taxId;
  final CardBrand brand;

  String get cleanCardNumber => cardNumber.replaceAll(' ', '');
  String get cleanTaxId => taxId.replaceAll(RegExp(r'\D'), '');
  bool get isCpf => cleanTaxId.length <= 11;

  int? get expiryMonth {
    final parts = expiryDate.split('/');
    return parts.length == 2 ? int.tryParse(parts[0]) : null;
  }

  int? get expiryYear {
    final parts = expiryDate.split('/');
    if (parts.length != 2) return null;
    final y = int.tryParse(parts[1]);
    return y == null ? null : 2000 + y;
  }

  @override
  String toString() {
    final last4 = cleanCardNumber.length >= 4
        ? cleanCardNumber.substring(cleanCardNumber.length - 4)
        : '****';
    return 'CardFormData(brand: $brand, last4: $last4)';
  }
}
