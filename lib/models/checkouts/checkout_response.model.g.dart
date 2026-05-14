// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_response.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutResponse _$CheckoutResponseFromJson(Map<String, dynamic> json) =>
    CheckoutResponse(
      paymentMethod: json['paymentMethod'] as String,
      paymentId: json['paymentId'] as String?,
      pix: json['pix'] == null
          ? null
          : PixData.fromJson(json['pix'] as Map<String, dynamic>),
      bill: json['bill'] == null
          ? null
          : BillData.fromJson(json['bill'] as Map<String, dynamic>),
      status: json['status'] as String?,
      depositRequestId: json['depositRequestId'] as String?,
      gatewayBaseUrl: json['gatewayBaseUrl'] as String?,
      publicKeyUrl: json['publicKeyUrl'] as String?,
    );

Map<String, dynamic> _$CheckoutResponseToJson(CheckoutResponse instance) =>
    <String, dynamic>{
      'paymentMethod': instance.paymentMethod,
      'paymentId': instance.paymentId,
      'pix': instance.pix?.toJson(),
      'bill': instance.bill?.toJson(),
      'status': instance.status,
      'depositRequestId': instance.depositRequestId,
      'gatewayBaseUrl': instance.gatewayBaseUrl,
      'publicKeyUrl': instance.publicKeyUrl,
    };
