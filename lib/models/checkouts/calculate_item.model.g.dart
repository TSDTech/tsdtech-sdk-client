// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculate_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculateItem _$CalculateItemFromJson(Map<String, dynamic> json) =>
    CalculateItem(
      serviceId: json['serviceId'] as String,
      value: (json['value'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CalculateItemToJson(CalculateItem instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'value': instance.value,
      'quantity': instance.quantity,
    };
