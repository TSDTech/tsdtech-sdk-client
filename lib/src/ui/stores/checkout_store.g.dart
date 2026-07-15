// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CheckoutStore on CheckoutStoreBase, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(
    () => super.hasError,
    name: 'CheckoutStoreBase.hasError',
  )).value;
  Computed<bool>? _$hasGeneratedPixComputed;

  @override
  bool get hasGeneratedPix => (_$hasGeneratedPixComputed ??= Computed<bool>(
    () => super.hasGeneratedPix,
    name: 'CheckoutStoreBase.hasGeneratedPix',
  )).value;
  Computed<bool>? _$isPixSelectedComputed;

  @override
  bool get isPixSelected => (_$isPixSelectedComputed ??= Computed<bool>(
    () => super.isPixSelected,
    name: 'CheckoutStoreBase.isPixSelected',
  )).value;
  Computed<bool>? _$isCardSelectedComputed;

  @override
  bool get isCardSelected => (_$isCardSelectedComputed ??= Computed<bool>(
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

  late final _$pixExpirationDateAtom = Atom(
    name: 'CheckoutStoreBase.pixExpirationDate',
    context: context,
  );

  @override
  String? get pixExpirationDate {
    _$pixExpirationDateAtom.reportRead();
    return super.pixExpirationDate;
  }

  @override
  set pixExpirationDate(String? value) {
    _$pixExpirationDateAtom.reportWrite(value, super.pixExpirationDate, () {
      super.pixExpirationDate = value;
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

  late final _$cardHolderNameAtom = Atom(
    name: 'CheckoutStoreBase.cardHolderName',
    context: context,
  );

  @override
  String get cardHolderName {
    _$cardHolderNameAtom.reportRead();
    return super.cardHolderName;
  }

  @override
  set cardHolderName(String value) {
    _$cardHolderNameAtom.reportWrite(value, super.cardHolderName, () {
      super.cardHolderName = value;
    });
  }

  late final _$cardNumberAtom = Atom(
    name: 'CheckoutStoreBase.cardNumber',
    context: context,
  );

  @override
  String get cardNumber {
    _$cardNumberAtom.reportRead();
    return super.cardNumber;
  }

  @override
  set cardNumber(String value) {
    _$cardNumberAtom.reportWrite(value, super.cardNumber, () {
      super.cardNumber = value;
    });
  }

  late final _$expiryDateAtom = Atom(
    name: 'CheckoutStoreBase.expiryDate',
    context: context,
  );

  @override
  String get expiryDate {
    _$expiryDateAtom.reportRead();
    return super.expiryDate;
  }

  @override
  set expiryDate(String value) {
    _$expiryDateAtom.reportWrite(value, super.expiryDate, () {
      super.expiryDate = value;
    });
  }

  late final _$feeAmountAtom = Atom(
    name: 'CheckoutStoreBase.feeAmount',
    context: context,
  );

  @override
  double? get feeAmount {
    _$feeAmountAtom.reportRead();
    return super.feeAmount;
  }

  @override
  set feeAmount(double? value) {
    _$feeAmountAtom.reportWrite(value, super.feeAmount, () {
      super.feeAmount = value;
    });
  }

  late final _$securityCodeAtom = Atom(
    name: 'CheckoutStoreBase.securityCode',
    context: context,
  );

  @override
  String get securityCode {
    _$securityCodeAtom.reportRead();
    return super.securityCode;
  }

  @override
  set securityCode(String value) {
    _$securityCodeAtom.reportWrite(value, super.securityCode, () {
      super.securityCode = value;
    });
  }

  late final _$cardFormVersionAtom = Atom(
    name: 'CheckoutStoreBase.cardFormVersion',
    context: context,
  );

  @override
  int get cardFormVersion {
    _$cardFormVersionAtom.reportRead();
    return super.cardFormVersion;
  }

  @override
  set cardFormVersion(int value) {
    _$cardFormVersionAtom.reportWrite(value, super.cardFormVersion, () {
      super.cardFormVersion = value;
    });
  }

  late final _$taxIdAtom = Atom(
    name: 'CheckoutStoreBase.taxId',
    context: context,
  );

  @override
  String get taxId {
    _$taxIdAtom.reportRead();
    return super.taxId;
  }

  @override
  set taxId(String value) {
    _$taxIdAtom.reportWrite(value, super.taxId, () {
      super.taxId = value;
    });
  }

  late final _$amountAtom = Atom(
    name: 'CheckoutStoreBase.amount',
    context: context,
  );

  @override
  double get amount {
    _$amountAtom.reportRead();
    return super.amount;
  }

  @override
  set amount(double value) {
    _$amountAtom.reportWrite(value, super.amount, () {
      super.amount = value;
    });
  }

  late final _$totalAmountAtom = Atom(
    name: 'CheckoutStoreBase.totalAmount',
    context: context,
  );

  @override
  double get totalAmount {
    _$totalAmountAtom.reportRead();
    return super.totalAmount;
  }

  @override
  set totalAmount(double value) {
    _$totalAmountAtom.reportWrite(value, super.totalAmount, () {
      super.totalAmount = value;
    });
  }

  late final _$itemsAtom = Atom(
    name: 'CheckoutStoreBase.items',
    context: context,
  );

  @override
  ObservableList<DepositRequestItemSummary> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(ObservableList<DepositRequestItemSummary> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$processPaymentAsyncAction = AsyncAction(
    'CheckoutStoreBase.processPayment',
    context: context,
  );

  @override
  Future<ValueResult<dynamic>> processPayment({
    required String depositRequestId,
    checkout_request.CheckoutRequest? request,
  }) {
    return _$processPaymentAsyncAction.run(
      () => super.processPayment(
        depositRequestId: depositRequestId,
        request: request,
      ),
    );
  }

  late final _$fetchOrderSummaryAsyncAction = AsyncAction(
    'CheckoutStoreBase.fetchOrderSummary',
    context: context,
  );

  @override
  Future<ValueResult<DepositRequestSummaryResponse>> fetchOrderSummary(
    String depositRequestId,
  ) {
    return _$fetchOrderSummaryAsyncAction.run(
      () => super.fetchOrderSummary(depositRequestId),
    );
  }

  late final _$fetchFeeAmountAsyncAction = AsyncAction(
    'CheckoutStoreBase.fetchFeeAmount',
    context: context,
  );

  @override
  Future<ValueResult<DepositRequestFeeResponse>> fetchFeeAmount(
    String depositRequestId,
    double amount,
    PaymentMethodType selectedMethod,
  ) {
    return _$fetchFeeAmountAsyncAction.run(
      () => super.fetchFeeAmount(depositRequestId, amount, selectedMethod),
    );
  }

  late final _$CheckoutStoreBaseActionController = ActionController(
    name: 'CheckoutStoreBase',
    context: context,
  );

  @override
  void updateCardHolderName(String value) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.updateCardHolderName',
    );
    try {
      return super.updateCardHolderName(value);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCardNumber(String value) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.updateCardNumber',
    );
    try {
      return super.updateCardNumber(value);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateExpiryDate(String value) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.updateExpiryDate',
    );
    try {
      return super.updateExpiryDate(value);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSecurityCode(String value) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.updateSecurityCode',
    );
    try {
      return super.updateSecurityCode(value);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateTaxId(String value) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.updateTaxId',
    );
    try {
      return super.updateTaxId(value);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetCardForm() {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.resetCardForm',
    );
    try {
      return super.resetCardForm();
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

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
  void setPixData({
    String? paymentId,
    String? qrCode,
    String? copyPasteCode,
    String? expirationDate,
  }) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.setPixData',
    );
    try {
      return super.setPixData(
        paymentId: paymentId,
        qrCode: qrCode,
        copyPasteCode: copyPasteCode,
        expirationDate: expirationDate,
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
  void setAmount(double value) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.setAmount',
    );
    try {
      return super.setAmount(value);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFeeAmount(double? value) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.setFeeAmount',
    );
    try {
      return super.setFeeAmount(value);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTotalAmount(double value) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.setTotalAmount',
    );
    try {
      return super.setTotalAmount(value);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setItems(List<DepositRequestItemSummary> newItems) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.setItems',
    );
    try {
      return super.setItems(newItems);
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
  void startPixPollingWithBackoff(
    String paymentId, {
    required VoidCallback onSuccess,
  }) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.startPixPollingWithBackoff',
    );
    try {
      return super.startPixPollingWithBackoff(paymentId, onSuccess: onSuccess);
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startCardPollingWithBackoff(
    String depositRequestId, {
    required VoidCallback onSuccess,
  }) {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.startCardPollingWithBackoff',
    );
    try {
      return super.startCardPollingWithBackoff(
        depositRequestId,
        onSuccess: onSuccess,
      );
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cancelPixPolling() {
    final _$actionInfo = _$CheckoutStoreBaseActionController.startAction(
      name: 'CheckoutStoreBase.cancelPixPolling',
    );
    try {
      return super.cancelPixPolling();
    } finally {
      _$CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedMethod: ${selectedMethod},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
pixQrCode: ${pixQrCode},
pixCopyPasteCode: ${pixCopyPasteCode},
pixExpirationDate: ${pixExpirationDate},
paymentId: ${paymentId},
paymentResult: ${paymentResult},
cardHolderName: ${cardHolderName},
cardNumber: ${cardNumber},
expiryDate: ${expiryDate},
feeAmount: ${feeAmount},
securityCode: ${securityCode},
cardFormVersion: ${cardFormVersion},
taxId: ${taxId},
amount: ${amount},
totalAmount: ${totalAmount},
items: ${items},
hasError: ${hasError},
hasGeneratedPix: ${hasGeneratedPix},
isPixSelected: ${isPixSelected},
isCardSelected: ${isCardSelected}
    ''';
  }
}
