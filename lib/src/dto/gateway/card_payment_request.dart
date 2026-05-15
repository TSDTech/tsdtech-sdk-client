import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';

part 'card_payment_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CardPaymentRequest {
  final String depositRequestId;
  final String encryptedCard;
  final String keyId;
  final int? installmentNumber;
  final BillPayerData? billPayer;

  CardPaymentRequest({
    required this.depositRequestId,
    required this.encryptedCard,
    required this.keyId,
    this.installmentNumber,
    this.billPayer,
  });

  factory CardPaymentRequest.fromJson(Map<String, dynamic> json) => _$CardPaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CardPaymentRequestToJson(this);
}
