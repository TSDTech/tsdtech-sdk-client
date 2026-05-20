// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_mock_response.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutMockResponse _$CheckoutMockResponseFromJson(
  Map<String, dynamic> json,
) => CheckoutMockResponse(
  id: json['id'] as String,
  paymentMethod: json['paymentMethod'] as String,
  status: json['status'] as String,
  textQrCode: json['textQrCode'] as String,
  pixPaymentIntentId: json['pixPaymentIntentId'] as String,
);

Map<String, dynamic> _$CheckoutMockResponseToJson(
  CheckoutMockResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'paymentMethod': instance.paymentMethod,
  'status': instance.status,
  'textQrCode': instance.textQrCode,
  'pixPaymentIntentId': instance.pixPaymentIntentId,
};
