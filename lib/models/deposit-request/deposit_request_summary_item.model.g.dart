// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_request_summary_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepositRequestItemSummary _$DepositRequestItemSummaryFromJson(
  Map<String, dynamic> json,
) => DepositRequestItemSummary(
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$DepositRequestItemSummaryToJson(
  DepositRequestItemSummary instance,
) => <String, dynamic>{
  'name': instance.name,
  'price': instance.price,
  'quantity': instance.quantity,
};
