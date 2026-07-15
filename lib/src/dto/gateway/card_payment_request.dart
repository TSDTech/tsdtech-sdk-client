import 'package:json_annotation/json_annotation.dart';

part 'card_payment_request.g.dart';

/// Payload enviado para processar um pagamento com cartão criptografado.
@JsonSerializable(explicitToJson: true)
class CardPaymentRequest {
  final String depositRequestId;
  final String encryptedCardData;
  final String keyId;
  final int? installmentNumber;
  final CardPayer? cardPayer;

  CardPaymentRequest({
    required this.depositRequestId,
    required this.encryptedCardData,
    required this.keyId,
    this.installmentNumber,
    this.cardPayer,
  });

  factory CardPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$CardPaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CardPaymentRequestToJson(this);
}

/// Dados do pagador do cartão (opcional). Alimenta o buyerCpf/buyerName
/// do payment intent no backend.
@JsonSerializable()
class CardPayer {
  final String? cardHolderName;
  final String? cpf;

  CardPayer({this.cardHolderName, this.cpf});

  factory CardPayer.fromJson(Map<String, dynamic> json) =>
      _$CardPayerFromJson(json);
  Map<String, dynamic> toJson() => _$CardPayerToJson(this);
}
