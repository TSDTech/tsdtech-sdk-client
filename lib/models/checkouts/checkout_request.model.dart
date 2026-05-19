import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_item.model.dart';

part 'checkout_request.model.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckoutRequest {
  final List<CalculateItem> cart;
  final String paymentMethod;
  final double totalValue;
  @Deprecated('Será removido nas próximas versões')
  final String? encryptedCard;
  @Deprecated('Será removido nas próximas versões')
  final CardPaymentData? card;
  final String? depositRequestId;
  final int? installmentNumber;

  CheckoutRequest({
    required this.cart,
    required this.paymentMethod,
    required this.totalValue,
    this.encryptedCard,
    this.card,
    this.depositRequestId,
    this.installmentNumber,
  });

  factory CheckoutRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckoutRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CheckoutRequestToJson(this);
}

@JsonSerializable()
class CardPaymentData {
  final String cardHolderName;
  final String cardNumber;
  final String cardExpiryDate;
  final String securityCode;
  final bool? preAuthorizedTransaction;

  CardPaymentData({
    required this.cardHolderName,
    required this.cardNumber,
    required this.cardExpiryDate,
    required this.securityCode,
    this.preAuthorizedTransaction,
  });

  factory CardPaymentData.fromJson(Map<String, dynamic> json) =>
      _$CardPaymentDataFromJson(json);
  Map<String, dynamic> toJson() => _$CardPaymentDataToJson(this);
}
