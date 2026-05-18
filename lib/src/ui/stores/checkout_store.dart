import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../checkout/payment_types.dart';

part 'checkout_store.g.dart';

class CheckoutStore = CheckoutStoreBase with _$CheckoutStore;

abstract class CheckoutStoreBase with Store {
  CheckoutStoreBase({
    PaymentMethodType initialMethod = PaymentMethodType.pix,
  })  : _initialMethod = initialMethod,
        selectedMethod = initialMethod;

  final PaymentMethodType _initialMethod;
  final GlobalKey<FormState> cardFormKey = GlobalKey<FormState>();
  Timer? _pixPollingTimer;

  @observable
  PaymentMethodType selectedMethod;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String? pixQrCode;

  @observable
  String? pixCopyPasteCode;

  @observable
  String? paymentId;

  @observable
  PaymentResult? paymentResult;

  @observable
  String cardHolderName = '';

  @observable
  String cardNumber = '';

  @observable
  String expiryDate = '';

  @observable
  String securityCode = '';

  @observable
  int cardFormVersion = 0;

  @computed
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  @computed
  bool get hasGeneratedPix => pixQrCode != null && pixQrCode!.isNotEmpty;

  @computed
  bool get isPixSelected => selectedMethod == PaymentMethodType.pix;

  @computed
  bool get isCardSelected => selectedMethod == PaymentMethodType.card;

  bool validateCardForm() => cardFormKey.currentState?.validate() ?? false;

  @action
  void updateCardHolderName(String value) => cardHolderName = value;

  @action
  void updateCardNumber(String value) => cardNumber = value;

  @action
  void updateExpiryDate(String value) => expiryDate = value;

  @action
  void updateSecurityCode(String value) => securityCode = value;

  @action
  void resetCardForm() {
    cardFormKey.currentState?.reset();
    cardHolderName = '';
    cardNumber = '';
    expiryDate = '';
    securityCode = '';
    cardFormVersion++;
  }

  @action
  void selectMethod(PaymentMethodType method) {
    if (selectedMethod == method) {
      return;
    }

    selectedMethod = method;
    clearError();
    clearPixData();
    cancelPixPolling();
  }

  @action
  void setLoading(bool value) => isLoading = value;

  @action
  void setError(String? message) {
    errorMessage = message;
    if (message != null && message.isNotEmpty) {
      paymentResult = null;
    }
  }

  @action
  void clearError() => errorMessage = null;

  @action
  void setPixData({
    String? paymentId,
    String? qrCode,
    String? copyPasteCode,
  }) {
    this.paymentId = paymentId;
    pixQrCode = qrCode;
    pixCopyPasteCode = copyPasteCode;
  }

  @action
  void clearPixData() {
    paymentId = null;
    pixQrCode = null;
    pixCopyPasteCode = null;
  }

  void startPixPolling(Timer timer) {
    cancelPixPolling();
    _pixPollingTimer = timer;
  }

  void cancelPixPolling() {
    _pixPollingTimer?.cancel();
    _pixPollingTimer = null;
  }

  @action
  void setPaymentResult(PaymentResult? result) {
    paymentResult = result;
    if (result != null) {
      errorMessage = null;
    }
  }

  @action
  void reset() {
    selectedMethod = _initialMethod;
    isLoading = false;
    errorMessage = null;
    pixQrCode = null;
    pixCopyPasteCode = null;
    paymentId = null;
    paymentResult = null;
    cancelPixPolling();
    resetCardForm();
  }

  void dispose() {
    cancelPixPolling();
  }
}