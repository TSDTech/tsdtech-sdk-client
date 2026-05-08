// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    PaymentMethodModel(
      paymentMethod: json['paymentMethod'] as String,
      isActive: json['isActive'] as bool,
      installmentNumber: (json['installmentNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaymentMethodModelToJson(PaymentMethodModel instance) =>
    <String, dynamic>{
      'paymentMethod': instance.paymentMethod,
      'isActive': instance.isActive,
      'installmentNumber': instance.installmentNumber,
    };
