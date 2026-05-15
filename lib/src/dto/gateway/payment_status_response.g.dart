// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentStatusResponse _$PaymentStatusResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentStatusResponse(
      status: $enumDecode(_$GatewayPaymentStatusEnumMap, json['status']),
      authorizationCode: json['authorizationCode'] as String?,
      nsu: json['nsu'] as String?,
      depositRequestId: json['depositRequestId'] as String?,
      message: json['message'] as String?,
      brand: json['brand'] as String?,
    );

Map<String, dynamic> _$PaymentStatusResponseToJson(
        PaymentStatusResponse instance) =>
    <String, dynamic>{
      'status': _$GatewayPaymentStatusEnumMap[instance.status]!,
      'authorizationCode': instance.authorizationCode,
      'nsu': instance.nsu,
      'depositRequestId': instance.depositRequestId,
      'message': instance.message,
      'brand': instance.brand,
    };

const _$GatewayPaymentStatusEnumMap = {
  GatewayPaymentStatus.processing: 'processing',
  GatewayPaymentStatus.approved: 'approved',
  GatewayPaymentStatus.declined: 'declined',
  GatewayPaymentStatus.failed: 'failed',
  GatewayPaymentStatus.cancelled: 'cancelled',
};
