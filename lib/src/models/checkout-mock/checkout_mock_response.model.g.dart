// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_mock_response.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepositPixResponse _$DepositPixResponseFromJson(Map<String, dynamic> json) =>
    DepositPixResponse(
      id: json['id'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      textQrCode: json['textQrCode'] as String,
      pixPaymentIntentId: json['pixPaymentIntentId'] as String,
      expirationDate: json['expirationDate'] as String?,
    );

Map<String, dynamic> _$DepositPixResponseToJson(DepositPixResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paymentMethod': instance.paymentMethod,
      'status': instance.status,
      'textQrCode': instance.textQrCode,
      'pixPaymentIntentId': instance.pixPaymentIntentId,
      'expirationDate': instance.expirationDate,
    };
