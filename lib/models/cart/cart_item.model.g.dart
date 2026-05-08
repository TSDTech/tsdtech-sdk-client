// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      service: Service.fromJson(json['service'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'service': instance.service.toJson(),
      'quantity': instance.quantity,
    };
