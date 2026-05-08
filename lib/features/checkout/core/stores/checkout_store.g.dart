// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CheckoutStore on _CheckoutStoreBase, Store {
  Computed<double>? _$totalComputed;

  @override
  double get total => (_$totalComputed ??=
          Computed<double>(() => super.total, name: '_CheckoutStoreBase.total'))
      .value;

  late final _$selectedPaymentAtom =
      Atom(name: '_CheckoutStoreBase.selectedPayment', context: context);

  @override
  PaymentMethod get selectedPayment {
    _$selectedPaymentAtom.reportRead();
    return super.selectedPayment;
  }

  @override
  set selectedPayment(PaymentMethod value) {
    _$selectedPaymentAtom.reportWrite(value, super.selectedPayment, () {
      super.selectedPayment = value;
    });
  }

  late final _$isProcessingAtom =
      Atom(name: '_CheckoutStoreBase.isProcessing', context: context);

  @override
  bool get isProcessing {
    _$isProcessingAtom.reportRead();
    return super.isProcessing;
  }

  @override
  set isProcessing(bool value) {
    _$isProcessingAtom.reportWrite(value, super.isProcessing, () {
      super.isProcessing = value;
    });
  }

  late final _$_totalAtom =
      Atom(name: '_CheckoutStoreBase._total', context: context);

  @override
  double get _total {
    _$_totalAtom.reportRead();
    return super._total;
  }

  @override
  set _total(double value) {
    _$_totalAtom.reportWrite(value, super._total, () {
      super._total = value;
    });
  }

  late final _$calculateTotalAsyncAction =
      AsyncAction('_CheckoutStoreBase.calculateTotal', context: context);

  @override
  Future<void> calculateTotal() {
    return _$calculateTotalAsyncAction.run(() => super.calculateTotal());
  }

  late final _$createCheckoutAsyncAction =
      AsyncAction('_CheckoutStoreBase.createCheckout', context: context);

  @override
  Future<ValueResult<CheckoutResponse>> createCheckout(
      {String? encryptedCard}) {
    return _$createCheckoutAsyncAction
        .run(() => super.createCheckout(encryptedCard: encryptedCard));
  }

  late final _$_CheckoutStoreBaseActionController =
      ActionController(name: '_CheckoutStoreBase', context: context);

  @override
  void selectPayment(PaymentMethod m) {
    final _$actionInfo = _$_CheckoutStoreBaseActionController.startAction(
        name: '_CheckoutStoreBase.selectPayment');
    try {
      return super.selectPayment(m);
    } finally {
      _$_CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectByIndex(int idx) {
    final _$actionInfo = _$_CheckoutStoreBaseActionController.startAction(
        name: '_CheckoutStoreBase.selectByIndex');
    try {
      return super.selectByIndex(idx);
    } finally {
      _$_CheckoutStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedPayment: ${selectedPayment},
isProcessing: ${isProcessing},
total: ${total}
    ''';
  }
}
