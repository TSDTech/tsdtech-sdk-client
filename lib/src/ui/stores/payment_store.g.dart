// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PaymentStore on PaymentStoreBase, Store {
  Computed<bool>? _$canInteractComputed;

  @override
  bool get canInteract =>
      (_$canInteractComputed ??= Computed<bool>(() => super.canInteract,
              name: 'PaymentStoreBase.canInteract'))
          .value;
  Computed<bool>? _$isCardSelectedComputed;

  @override
  bool get isCardSelected =>
      (_$isCardSelectedComputed ??= Computed<bool>(() => super.isCardSelected,
              name: 'PaymentStoreBase.isCardSelected'))
          .value;
  Computed<bool>? _$isPixSelectedComputed;

  @override
  bool get isPixSelected =>
      (_$isPixSelectedComputed ??= Computed<bool>(() => super.isPixSelected,
              name: 'PaymentStoreBase.isPixSelected'))
          .value;
  Computed<CardFormData?>? _$selectedCardDataComputed;

  @override
  CardFormData? get selectedCardData => (_$selectedCardDataComputed ??=
          Computed<CardFormData?>(() => super.selectedCardData,
              name: 'PaymentStoreBase.selectedCardData'))
      .value;
  Computed<PaymentFormData>? _$currentDataComputed;

  @override
  PaymentFormData get currentData => (_$currentDataComputed ??=
          Computed<PaymentFormData>(() => super.currentData,
              name: 'PaymentStoreBase.currentData'))
      .value;

  late final _$selectedMethodAtom =
      Atom(name: 'PaymentStoreBase.selectedMethod', context: context);

  @override
  PaymentFormMethod get selectedMethod {
    _$selectedMethodAtom.reportRead();
    return super.selectedMethod;
  }

  @override
  set selectedMethod(PaymentFormMethod value) {
    _$selectedMethodAtom.reportWrite(value, super.selectedMethod, () {
      super.selectedMethod = value;
    });
  }

  late final _$enabledAtom =
      Atom(name: 'PaymentStoreBase.enabled', context: context);

  @override
  bool get enabled {
    _$enabledAtom.reportRead();
    return super.enabled;
  }

  @override
  set enabled(bool value) {
    _$enabledAtom.reportWrite(value, super.enabled, () {
      super.enabled = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'PaymentStoreBase.isLoading', context: context);

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

  late final _$lastSubmittedDataAtom =
      Atom(name: 'PaymentStoreBase.lastSubmittedData', context: context);

  @override
  PaymentFormData? get lastSubmittedData {
    _$lastSubmittedDataAtom.reportRead();
    return super.lastSubmittedData;
  }

  @override
  set lastSubmittedData(PaymentFormData? value) {
    _$lastSubmittedDataAtom.reportWrite(value, super.lastSubmittedData, () {
      super.lastSubmittedData = value;
    });
  }

  late final _$PaymentStoreBaseActionController =
      ActionController(name: 'PaymentStoreBase', context: context);

  @override
  void selectMethod(PaymentFormMethod method) {
    final _$actionInfo = _$PaymentStoreBaseActionController.startAction(
        name: 'PaymentStoreBase.selectMethod');
    try {
      return super.selectMethod(method);
    } finally {
      _$PaymentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEnabled(bool value) {
    final _$actionInfo = _$PaymentStoreBaseActionController.startAction(
        name: 'PaymentStoreBase.setEnabled');
    try {
      return super.setEnabled(value);
    } finally {
      _$PaymentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$PaymentStoreBaseActionController.startAction(
        name: 'PaymentStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$PaymentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCardData(CardFormData value) {
    final _$actionInfo = _$PaymentStoreBaseActionController.startAction(
        name: 'PaymentStoreBase.setCardData');
    try {
      return super.setCardData(value);
    } finally {
      _$PaymentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markSubmitted() {
    final _$actionInfo = _$PaymentStoreBaseActionController.startAction(
        name: 'PaymentStoreBase.markSubmitted');
    try {
      return super.markSubmitted();
    } finally {
      _$PaymentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSubmission() {
    final _$actionInfo = _$PaymentStoreBaseActionController.startAction(
        name: 'PaymentStoreBase.clearSubmission');
    try {
      return super.clearSubmission();
    } finally {
      _$PaymentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$PaymentStoreBaseActionController.startAction(
        name: 'PaymentStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$PaymentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedMethod: ${selectedMethod},
enabled: ${enabled},
isLoading: ${isLoading},
lastSubmittedData: ${lastSubmittedData},
canInteract: ${canInteract},
isCardSelected: ${isCardSelected},
isPixSelected: ${isPixSelected},
selectedCardData: ${selectedCardData},
currentData: ${currentData}
    ''';
  }
}
