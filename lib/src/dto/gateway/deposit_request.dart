import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/src/dto/gateway/payment_method.enum.dart';

part 'deposit_request.g.dart';

@JsonSerializable(explicitToJson: true)
class DepositRequest {
  final String depositRequestId;
  final PaymentMethod? paymentMethod;

  DepositRequest({required this.depositRequestId, this.paymentMethod});

  factory DepositRequest.fromJson(Map<String, dynamic> json) =>
      _$DepositRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DepositRequestToJson(this);
}
