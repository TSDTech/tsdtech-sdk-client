// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_request_summary.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepositRequestSummaryResponse _$DepositRequestSummaryResponseFromJson(
  Map<String, dynamic> json,
) => DepositRequestSummaryResponse(
  id: json['id'] as String,
  amount: (json['amount'] as num).toDouble(),
  totalAmount: (json['totalAmount'] as num?)?.toDouble(),
  createdAtUtc: json['createdAtUtc'] as String,
  depositRequestId: json['depositRequestId'] as String,
  feeAmount: (json['feeAmount'] as num?)?.toDouble(),
  itemsSummary: (json['items_summary'] as List<dynamic>)
      .map((e) => DepositRequestItemSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DepositRequestSummaryResponseToJson(
  DepositRequestSummaryResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'totalAmount': instance.totalAmount,
  'createdAtUtc': instance.createdAtUtc,
  'depositRequestId': instance.depositRequestId,
  'feeAmount': instance.feeAmount,
  'items_summary': instance.itemsSummary.map((e) => e.toJson()).toList(),
};
