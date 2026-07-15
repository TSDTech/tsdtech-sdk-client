// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardPaymentRequest _$CardPaymentRequestFromJson(Map<String, dynamic> json) =>
    CardPaymentRequest(
      depositRequestId: json['depositRequestId'] as String,
      encryptedCardData: json['encryptedCardData'] as String,
      keyId: json['keyId'] as String,
      installmentNumber: (json['installmentNumber'] as num?)?.toInt(),
      cardPayer: json['cardPayer'] == null
          ? null
          : CardPayer.fromJson(json['cardPayer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CardPaymentRequestToJson(CardPaymentRequest instance) =>
    <String, dynamic>{
      'depositRequestId': instance.depositRequestId,
      'encryptedCardData': instance.encryptedCardData,
      'keyId': instance.keyId,
      'installmentNumber': instance.installmentNumber,
      'cardPayer': instance.cardPayer?.toJson(),
    };

CardPayer _$CardPayerFromJson(Map<String, dynamic> json) => CardPayer(
  cardHolderName: json['cardHolderName'] as String?,
  cpf: json['cpf'] as String?,
);

Map<String, dynamic> _$CardPayerToJson(CardPayer instance) =>
    <String, dynamic>{
      'cardHolderName': instance.cardHolderName,
      'cpf': instance.cpf,
    };
