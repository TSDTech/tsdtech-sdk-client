// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_card_response.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepositCardResponse _$DepositCardResponseFromJson(Map<String, dynamic> json) =>
    DepositCardResponse(
      id: json['id'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      cardPaymentIntentId: json['cardPaymentIntentId'] as String?,
      expirationDate: json['expirationDate'] as String?,
    );

Map<String, dynamic> _$DepositCardResponseToJson(
  DepositCardResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'paymentMethod': instance.paymentMethod,
  'status': instance.status,
  'cardPaymentIntentId': instance.cardPaymentIntentId,
  'expirationDate': instance.expirationDate,
};
