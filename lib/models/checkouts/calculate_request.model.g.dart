// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculate_request.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculateRequest _$CalculateRequestFromJson(Map<String, dynamic> json) =>
    CalculateRequest(
      cart: (json['cart'] as List<dynamic>)
          .map((e) => CalculateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CalculateRequestToJson(CalculateRequest instance) =>
    <String, dynamic>{'cart': instance.cart.map((e) => e.toJson()).toList()};
