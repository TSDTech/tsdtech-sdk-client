// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_request.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutRequest _$CheckoutRequestFromJson(Map<String, dynamic> json) =>
    CheckoutRequest(
      cart: (json['cart'] as List<dynamic>)
          .map((e) => CalculateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethod: json['paymentMethod'] as String,
      totalValue: (json['totalValue'] as num).toDouble(),
      encryptedCard: json['encryptedCard'] as String?,
      card: json['card'] == null
          ? null
          : CardPaymentData.fromJson(json['card'] as Map<String, dynamic>),
      depositRequestId: json['depositRequestId'] as String?,
      installmentNumber: (json['installmentNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CheckoutRequestToJson(CheckoutRequest instance) =>
    <String, dynamic>{
      'cart': instance.cart.map((e) => e.toJson()).toList(),
      'paymentMethod': instance.paymentMethod,
      'totalValue': instance.totalValue,
      'encryptedCard': instance.encryptedCard,
      'card': instance.card?.toJson(),
      'depositRequestId': instance.depositRequestId,
      'installmentNumber': instance.installmentNumber,
    };

CardPaymentData _$CardPaymentDataFromJson(Map<String, dynamic> json) =>
    CardPaymentData(
      cardHolderName: json['cardHolderName'] as String,
      cardNumber: json['cardNumber'] as String,
      cardExpiryDate: json['cardExpiryDate'] as String,
      securityCode: json['securityCode'] as String,
      preAuthorizedTransaction: json['preAuthorizedTransaction'] as bool?,
      taxId: json['taxId'] as String?,
    );

Map<String, dynamic> _$CardPaymentDataToJson(CardPaymentData instance) =>
    <String, dynamic>{
      'cardHolderName': instance.cardHolderName,
      'cardNumber': instance.cardNumber,
      'cardExpiryDate': instance.cardExpiryDate,
      'securityCode': instance.securityCode,
      'preAuthorizedTransaction': instance.preAuthorizedTransaction,
      'taxId': instance.taxId,
    };
