import 'package:json_annotation/json_annotation.dart';

part 'deposit_request_fee.model.g.dart';

@JsonSerializable(explicitToJson: true)
class DepositRequestFeeResponse {
  final double? feeAmount;

  DepositRequestFeeResponse({this.feeAmount});

  factory DepositRequestFeeResponse.fromJson(Map<String, dynamic> json) => _$DepositRequestFeeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DepositRequestFeeResponseToJson(this);
}
