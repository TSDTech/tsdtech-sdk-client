// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculate_response.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculateResponse _$CalculateResponseFromJson(Map<String, dynamic> json) =>
    CalculateResponse(
      totalValue: (json['totalValue'] as num).toDouble(),
      cart: (json['cart'] as List<dynamic>?)
          ?.map((e) => CalculateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CalculateResponseToJson(CalculateResponse instance) =>
    <String, dynamic>{'totalValue': instance.totalValue, 'cart': instance.cart};
