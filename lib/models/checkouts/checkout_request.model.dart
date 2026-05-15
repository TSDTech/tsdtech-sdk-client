import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_item.model.dart';

part 'checkout_request.model.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckoutRequest {
  final List<CalculateItem> cart;
  final String paymentMethod;
  final double totalValue;
  @deprecated
  final String? encryptedCard;
  @deprecated 
  final CardPaymentData? card;
  final String? depositRequestId;
  final BillPayerData? billPayer;
  final String? billDueDate;
  final String? billInstructions;
  final int? installmentNumber;

  CheckoutRequest({
    required this.cart,
    required this.paymentMethod,
    required this.totalValue,
    this.encryptedCard,
    this.card,
    this.depositRequestId,
    this.billPayer,
    this.billDueDate,
    this.billInstructions,
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

@JsonSerializable()
class BillPayerData {
  final String name;
  final String address;
  final String neighborhood;
  final String city;
  final String zipCode;
  final String state;

  BillPayerData({
    required this.name,
    required this.address,
    required this.neighborhood,
    required this.city,
    required this.zipCode,
    required this.state,
  });

  factory BillPayerData.fromJson(Map<String, dynamic> json) =>
      _$BillPayerDataFromJson(json);
  Map<String, dynamic> toJson() => _$BillPayerDataToJson(this);
}
