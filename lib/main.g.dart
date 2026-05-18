// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExampleShowcaseStore on ExampleShowcaseStoreBase, Store {
  late final _$presetAtom =
      Atom(name: 'ExampleShowcaseStoreBase.preset', context: context);

  @override
  DemoThemePreset get preset {
    _$presetAtom.reportRead();
    return super.preset;
  }

  @override
  set preset(DemoThemePreset value) {
    _$presetAtom.reportWrite(value, super.preset, () {
      super.preset = value;
    });
  }

  late final _$paymentFormResultAtom = Atom(
      name: 'ExampleShowcaseStoreBase.paymentFormResult', context: context);

  @override
  PaymentFormData? get paymentFormResult {
    _$paymentFormResultAtom.reportRead();
    return super.paymentFormResult;
  }

  @override
  set paymentFormResult(PaymentFormData? value) {
    _$paymentFormResultAtom.reportWrite(value, super.paymentFormResult, () {
      super.paymentFormResult = value;
    });
  }

  late final _$cardPreviewAtom =
      Atom(name: 'ExampleShowcaseStoreBase.cardPreview', context: context);

  @override
  CardFormData? get cardPreview {
    _$cardPreviewAtom.reportRead();
    return super.cardPreview;
  }

  @override
  set cardPreview(CardFormData? value) {
    _$cardPreviewAtom.reportWrite(value, super.cardPreview, () {
      super.cardPreview = value;
    });
  }

  late final _$checkoutStatusAtom =
      Atom(name: 'ExampleShowcaseStoreBase.checkoutStatus', context: context);

  @override
  PaymentStatus? get checkoutStatus {
    _$checkoutStatusAtom.reportRead();
    return super.checkoutStatus;
  }

  @override
  set checkoutStatus(PaymentStatus? value) {
    _$checkoutStatusAtom.reportWrite(value, super.checkoutStatus, () {
      super.checkoutStatus = value;
    });
  }

  late final _$ExampleShowcaseStoreBaseActionController =
      ActionController(name: 'ExampleShowcaseStoreBase', context: context);

  @override
  void setPreset(DemoThemePreset value) {
    final _$actionInfo = _$ExampleShowcaseStoreBaseActionController.startAction(
        name: 'ExampleShowcaseStoreBase.setPreset');
    try {
      return super.setPreset(value);
    } finally {
      _$ExampleShowcaseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPaymentFormResult(PaymentFormData? value) {
    final _$actionInfo = _$ExampleShowcaseStoreBaseActionController.startAction(
        name: 'ExampleShowcaseStoreBase.setPaymentFormResult');
    try {
      return super.setPaymentFormResult(value);
    } finally {
      _$ExampleShowcaseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCardPreview(CardFormData? value) {
    final _$actionInfo = _$ExampleShowcaseStoreBaseActionController.startAction(
        name: 'ExampleShowcaseStoreBase.setCardPreview');
    try {
      return super.setCardPreview(value);
    } finally {
      _$ExampleShowcaseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCheckoutStatus(PaymentStatus? value) {
    final _$actionInfo = _$ExampleShowcaseStoreBaseActionController.startAction(
        name: 'ExampleShowcaseStoreBase.setCheckoutStatus');
    try {
      return super.setCheckoutStatus(value);
    } finally {
      _$ExampleShowcaseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
preset: ${preset},
paymentFormResult: ${paymentFormResult},
cardPreview: ${cardPreview},
checkoutStatus: ${checkoutStatus}
    ''';
  }
}
