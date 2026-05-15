// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardPaymentRequest _$CardPaymentRequestFromJson(Map<String, dynamic> json) =>
    CardPaymentRequest(
      depositRequestId: json['depositRequestId'] as String,
      encryptedCard: json['encryptedCard'] as String,
      keyId: json['keyId'] as String,
      installmentNumber: (json['installmentNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CardPaymentRequestToJson(CardPaymentRequest instance) =>
    <String, dynamic>{
      'depositRequestId': instance.depositRequestId,
      'encryptedCard': instance.encryptedCard,
      'keyId': instance.keyId,
      'installmentNumber': instance.installmentNumber,
    };
