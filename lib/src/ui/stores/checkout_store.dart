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

  @computed
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  @computed
  bool get hasGeneratedPix => pixQrCode != null && pixQrCode!.isNotEmpty;

  @computed
  bool get isPixSelected => selectedMethod == PaymentMethodType.pix;

  @computed
  bool get isCardSelected => selectedMethod == PaymentMethodType.card;

  @action
  void selectMethod(PaymentMethodType method) {
    if (selectedMethod == method) {
      return;
    }

    selectedMethod = method;
    clearError();
    clearPixData();
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
  }
}