// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CardFormStore on CardFormStoreBase, Store {
  Computed<CardFormData>? _$dataComputed;

  @override
  CardFormData get data => (_$dataComputed ??= Computed<CardFormData>(
    () => super.data,
    name: 'CardFormStoreBase.data',
  )).value;
  Computed<bool>? _$isAmexComputed;

  @override
  bool get isAmex => (_$isAmexComputed ??= Computed<bool>(
    () => super.isAmex,
    name: 'CardFormStoreBase.isAmex',
  )).value;
  Computed<bool>? _$isEmptyComputed;

  @override
  bool get isEmpty => (_$isEmptyComputed ??= Computed<bool>(
    () => super.isEmpty,
    name: 'CardFormStoreBase.isEmpty',
  )).value;

  late final _$cardNumberAtom = Atom(
    name: 'CardFormStoreBase.cardNumber',
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

  late final _$cardholderNameAtom = Atom(
    name: 'CardFormStoreBase.cardholderName',
    context: context,
  );

  @override
  String get cardholderName {
    _$cardholderNameAtom.reportRead();
    return super.cardholderName;
  }

  @override
  set cardholderName(String value) {
    _$cardholderNameAtom.reportWrite(value, super.cardholderName, () {
      super.cardholderName = value;
    });
  }

  late final _$expiryDateAtom = Atom(
    name: 'CardFormStoreBase.expiryDate',
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

  late final _$cvvAtom = Atom(name: 'CardFormStoreBase.cvv', context: context);

  @override
  String get cvv {
    _$cvvAtom.reportRead();
    return super.cvv;
  }

  @override
  set cvv(String value) {
    _$cvvAtom.reportWrite(value, super.cvv, () {
      super.cvv = value;
    });
  }

  late final _$taxIdAtom = Atom(
    name: 'CardFormStoreBase.taxId',
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

  late final _$brandAtom = Atom(
    name: 'CardFormStoreBase.brand',
    context: context,
  );

  @override
  CardBrand get brand {
    _$brandAtom.reportRead();
    return super.brand;
  }

  @override
  set brand(CardBrand value) {
    _$brandAtom.reportWrite(value, super.brand, () {
      super.brand = value;
    });
  }

  late final _$formVersionAtom = Atom(
    name: 'CardFormStoreBase.formVersion',
    context: context,
  );

  @override
  int get formVersion {
    _$formVersionAtom.reportRead();
    return super.formVersion;
  }

  @override
  set formVersion(int value) {
    _$formVersionAtom.reportWrite(value, super.formVersion, () {
      super.formVersion = value;
    });
  }

  late final _$cvvFieldVersionAtom = Atom(
    name: 'CardFormStoreBase.cvvFieldVersion',
    context: context,
  );

  @override
  int get cvvFieldVersion {
    _$cvvFieldVersionAtom.reportRead();
    return super.cvvFieldVersion;
  }

  @override
  set cvvFieldVersion(int value) {
    _$cvvFieldVersionAtom.reportWrite(value, super.cvvFieldVersion, () {
      super.cvvFieldVersion = value;
    });
  }

  late final _$CardFormStoreBaseActionController = ActionController(
    name: 'CardFormStoreBase',
    context: context,
  );

  @override
  void updateCardNumber(String value) {
    final _$actionInfo = _$CardFormStoreBaseActionController.startAction(
      name: 'CardFormStoreBase.updateCardNumber',
    );
    try {
      return super.updateCardNumber(value);
    } finally {
      _$CardFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCardholderName(String value) {
    final _$actionInfo = _$CardFormStoreBaseActionController.startAction(
      name: 'CardFormStoreBase.updateCardholderName',
    );
    try {
      return super.updateCardholderName(value);
    } finally {
      _$CardFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateExpiryDate(String value) {
    final _$actionInfo = _$CardFormStoreBaseActionController.startAction(
      name: 'CardFormStoreBase.updateExpiryDate',
    );
    try {
      return super.updateExpiryDate(value);
    } finally {
      _$CardFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCvv(String value) {
    final _$actionInfo = _$CardFormStoreBaseActionController.startAction(
      name: 'CardFormStoreBase.updateCvv',
    );
    try {
      return super.updateCvv(value);
    } finally {
      _$CardFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCvv() {
    final _$actionInfo = _$CardFormStoreBaseActionController.startAction(
      name: 'CardFormStoreBase.clearCvv',
    );
    try {
      return super.clearCvv();
    } finally {
      _$CardFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateTaxId(String value) {
    final _$actionInfo = _$CardFormStoreBaseActionController.startAction(
      name: 'CardFormStoreBase.updateTaxId',
    );
    try {
      return super.updateTaxId(value);
    } finally {
      _$CardFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBrand(CardBrand value) {
    final _$actionInfo = _$CardFormStoreBaseActionController.startAction(
      name: 'CardFormStoreBase.setBrand',
    );
    try {
      return super.setBrand(value);
    } finally {
      _$CardFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setData(CardFormData value) {
    final _$actionInfo = _$CardFormStoreBaseActionController.startAction(
      name: 'CardFormStoreBase.setData',
    );
    try {
      return super.setData(value);
    } finally {
      _$CardFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$CardFormStoreBaseActionController.startAction(
      name: 'CardFormStoreBase.reset',
    );
    try {
      return super.reset();
    } finally {
      _$CardFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$CardFormStoreBaseActionController.startAction(
      name: 'CardFormStoreBase.resetForm',
    );
    try {
      return super.resetForm();
    } finally {
      _$CardFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cardNumber: ${cardNumber},
cardholderName: ${cardholderName},
expiryDate: ${expiryDate},
cvv: ${cvv},
taxId: ${taxId},
brand: ${brand},
formVersion: ${formVersion},
cvvFieldVersion: ${cvvFieldVersion},
data: ${data},
isAmex: ${isAmex},
isEmpty: ${isEmpty}
    ''';
  }
}
