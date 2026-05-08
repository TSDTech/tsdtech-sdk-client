// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_info.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPaymentInfo _$OrderPaymentInfoFromJson(Map<String, dynamic> json) =>
    OrderPaymentInfo(
      id: json['id'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      cartTotalValue: (json['cartTotalValue'] as num?)?.toDouble(),
      installmentNumber: (json['installmentNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderPaymentInfoToJson(OrderPaymentInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paymentMethod': instance.paymentMethod,
      'cartTotalValue': instance.cartTotalValue,
      'installmentNumber': instance.installmentNumber,
    };
