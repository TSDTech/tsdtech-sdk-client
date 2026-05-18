// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

mixin _$CheckoutStore on CheckoutStoreBase, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(
        () => super.hasError,
        name: 'CheckoutStoreBase.hasError',
      )).value;
  Computed<bool>? _$hasGeneratedPixComputed;

  @override
  bool get hasGeneratedPix =>
      (_$hasGeneratedPixComputed ??= Computed<bool>(
        () => super.hasGeneratedPix,
        name: 'CheckoutStoreBase.hasGeneratedPix',
      )).value;
  Computed<bool>? _$isPixSelectedComputed;

  @override
  bool get isPixSelected =>
      (_$isPixSelectedComputed ??= Computed<bool>(
        () => super.isPixSelected,
        name: 'CheckoutStoreBase.isPixSelected',
      )).value;
  Computed<bool>? _$isCardSelectedComputed;

  @override
  bool get isCardSelected =>
      (_$isCardSelectedComputed ??= Computed<bool>(
        () => super.isCardSelected,
        name: 'CheckoutStoreBase.isCardSelected',
      )).value;

  late final _$selectedMethodAtom = Atom(
    name: 'CheckoutStoreBase.selectedMethod',
    context: context,
  );

  @override
  PaymentMethodType get selectedMethod {
    _$selectedMethodAtom.reportRead();
    return super.selectedMethod;
  }

  @override
  set selectedMethod(PaymentMethodType value) {
    _$selectedMethodAtom.reportWrite(value, super.selectedMethod, () {
      super.selectedMethod = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: 'CheckoutStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'CheckoutStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$pixQrCodeAtom = Atom(
    name: 'CheckoutStoreBase.pixQrCode',
    context: context,
  );

  @override
  String? get pixQrCode {
    _$pixQrCodeAtom.reportRead();
    return super.pixQrCode;
  }

  @override
  set pixQrCode(String? value) {
    _$pixQrCodeAtom.reportWrite(value, super.pixQrCode, () {
      super.pixQrCode = value;
    });
  }

  late final _$pixCopyPasteCodeAtom = Atom(
    name: 'CheckoutStoreBase.pixCopyPasteCode',
    context: context,
  );

  @override
  String? get pixCopyPasteCode {
    _$pixCopyPasteCodeAtom.reportRead();
    return super.pixCopyPasteCode;
  }

  @override
  set pixCopyPasteCode(String? value) {
    _$pixCopyPasteCodeAtom.reportWrite(value, super.pixCopyPasteCode, () {
      super.pixCopyPasteCode = value;
    });
  }

  late final _$paymentIdAtom = Atom(
    name: 'CheckoutStoreBase.paymentId',
    context: context,
  );

  @override
  String? get paymentId {
    _$paymentIdAtom.reportRead();
    return super.paymentId;
  }

  @override
  set paymentId(String? value) {
    _$paymentIdAtom.reportWrite(value, super.paymentId, () {
      super.paymentId = value;
    });
  }

  late final _$paymentResultAtom = Atom(
    name: 'CheckoutStoreBase.paymentResult',
    context: context,
  );

  @override
  PaymentResult? get paymentResult {
    _$paymentResultAtom.reportRead();
    return super.paymentResult;
  }

  @override
  set paymentResult(PaymentResult? value) {
    _$paymentResultAtom.reportWrite(value, super.paymentResult, () {
      super.paymentResult = value;
    });
  }

  late final _$CheckoutStoreBaseActionController = ActionController(
    name: 'CheckoutStoreBase',
    context: context,
  );

  @override
  void selectMethod(PaymentMethodType method) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.selectMethod',
    );
    try {
      return super.selectMethod(method);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.setLoading',
    );
    try {
      return super.setLoading(value);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? message) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.setError',
    );
    try {
      return super.setError(message);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPixData({String? paymentId, String? qrCode, String? copyPasteCode}) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.setPixData',
    );
    try {
      return super.setPixData(
        paymentId: paymentId,
        qrCode: qrCode,
        copyPasteCode: copyPasteCode,
      );
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearPixData() {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.clearPixData',
    );
    try {
      return super.clearPixData();
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPaymentResult(PaymentResult? result) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.setPaymentResult',
    );
    try {
      return super.setPaymentResult(result);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.reset',
    );
    try {
      return super.reset();
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''selectedMethod: ${selectedMethod}, isLoading: ${isLoading}, errorMessage: ${errorMessage}, pixQrCode: ${pixQrCode}, pixCopyPasteCode: ${pixCopyPasteCode}, paymentId: ${paymentId}, paymentResult: ${paymentResult}, hasError: ${hasError}, hasGeneratedPix: ${hasGeneratedPix}, isPixSelected: ${isPixSelected}, isCardSelected: ${isCardSelected}''';
  }
}