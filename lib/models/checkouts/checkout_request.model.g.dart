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
      billPayer: json['billPayer'] == null
          ? null
          : BillPayerData.fromJson(json['billPayer'] as Map<String, dynamic>),
      billDueDate: json['billDueDate'] as String?,
      billInstructions: json['billInstructions'] as String?,
      installmentNumber: (json['installmentNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CheckoutRequestToJson(CheckoutRequest instance) =>
    <String, dynamic>{
      'cart': instance.cart.map((e) => e.toJson()).toList(),
      'paymentMethod': instance.paymentMethod,
      'totalValue': instance.totalValue,
      'encryptedCard': instance.encryptedCard,
      'card': instance.card?.toJson(),
      'billPayer': instance.billPayer?.toJson(),
      'billDueDate': instance.billDueDate,
      'billInstructions': instance.billInstructions,
      'installmentNumber': instance.installmentNumber,
    };

CardPaymentData _$CardPaymentDataFromJson(Map<String, dynamic> json) =>
    CardPaymentData(
      cardHolderName: json['cardHolderName'] as String,
      cardNumber: json['cardNumber'] as String,
      cardExpiryDate: json['cardExpiryDate'] as String,
      securityCode: json['securityCode'] as String,
      preAuthorizedTransaction: json['preAuthorizedTransaction'] as bool?,
    );

Map<String, dynamic> _$CardPaymentDataToJson(CardPaymentData instance) =>
    <String, dynamic>{
      'cardHolderName': instance.cardHolderName,
      'cardNumber': instance.cardNumber,
      'cardExpiryDate': instance.cardExpiryDate,
      'securityCode': instance.securityCode,
      'preAuthorizedTransaction': instance.preAuthorizedTransaction,
    };

BillPayerData _$BillPayerDataFromJson(Map<String, dynamic> json) =>
    BillPayerData(
      name: json['name'] as String,
      address: json['address'] as String,
      neighborhood: json['neighborhood'] as String,
      city: json['city'] as String,
      zipCode: json['zipCode'] as String,
      state: json['state'] as String,
    );

Map<String, dynamic> _$BillPayerDataToJson(BillPayerData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'neighborhood': instance.neighborhood,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'state': instance.state,
    };
