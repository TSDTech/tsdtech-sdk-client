import 'package:json_annotation/json_annotation.dart';

// Lembre-se de rodar o build_runner para gerar esse arquivo .g.dart
part 'deposit_card_response.model.g.dart';

@JsonSerializable(explicitToJson: true)
class DepositCardResponse {
  final String id;
  final String paymentMethod;
  final String status;
  final String? cardPaymentIntentId;
  final String? expirationDate;

  DepositCardResponse({
    required this.id,
    required this.paymentMethod,
    required this.status,
    this.cardPaymentIntentId,
    this.expirationDate,
  });

  factory DepositCardResponse.fromJson(Map<String, dynamic> json) =>
      _$DepositCardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepositCardResponseToJson(this);
}
