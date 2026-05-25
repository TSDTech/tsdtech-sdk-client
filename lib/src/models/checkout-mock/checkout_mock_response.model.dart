import 'package:json_annotation/json_annotation.dart';

// Lembre-se de rodar o build_runner para gerar esse arquivo .g.dart
part 'checkout_mock_response.model.g.dart';

@JsonSerializable(explicitToJson: true)
class DepositPixResponse {
  final String id;
  final String paymentMethod;
  final String status;
  final String textQrCode;
  final String pixPaymentIntentId;
  final String? expirationDate;

  DepositPixResponse({
    required this.id,
    required this.paymentMethod,
    required this.status,
    required this.textQrCode,
    required this.pixPaymentIntentId,
    this.expirationDate,
  });

  factory DepositPixResponse.fromJson(Map<String, dynamic> json) =>
      _$DepositPixResponseFromJson(json);
      
  Map<String, dynamic> toJson() => _$DepositPixResponseToJson(this);
}