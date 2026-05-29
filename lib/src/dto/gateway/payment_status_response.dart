import 'package:json_annotation/json_annotation.dart';
import 'gateway_payment_status.dart';

part 'payment_status_response.g.dart';

/// DTO contendo o status final do processamento no Gateway.
@JsonSerializable()
class PaymentStatusResponse {
  final GatewayPaymentStatus status;
  final String? authorizationCode;
  final String? nsu;
  final String? depositRequestId;
  final String? message;
  final String? brand;

  PaymentStatusResponse({
    required this.status,
    this.authorizationCode,
    this.nsu,
    this.depositRequestId,
    this.message,
    this.brand,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentStatusResponseToJson(this);
}
