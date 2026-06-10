// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_request_fee.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepositRequestFeeResponse _$DepositRequestFeeResponseFromJson(
  Map<String, dynamic> json,
) => DepositRequestFeeResponse(
  feeAmount: (json['feeAmount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DepositRequestFeeResponseToJson(
  DepositRequestFeeResponse instance,
) => <String, dynamic>{'feeAmount': instance.feeAmount};
