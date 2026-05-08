// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_type_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignupTypeStore on _SignupTypeStore, Store {
  late final _$selectedAtom =
      Atom(name: '_SignupTypeStore.selected', context: context);

  @override
  SignupType? get selected {
    _$selectedAtom.reportRead();
    return super.selected;
  }

  @override
  set selected(SignupType? value) {
    _$selectedAtom.reportWrite(value, super.selected, () {
      super.selected = value;
    });
  }

  late final _$_SignupTypeStoreActionController =
      ActionController(name: '_SignupTypeStore', context: context);

  @override
  void selectPerson() {
    final _$actionInfo = _$_SignupTypeStoreActionController.startAction(
        name: '_SignupTypeStore.selectPerson');
    try {
      return super.selectPerson();
    } finally {
      _$_SignupTypeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectCompany() {
    final _$actionInfo = _$_SignupTypeStoreActionController.startAction(
        name: '_SignupTypeStore.selectCompany');
    try {
      return super.selectCompany();
    } finally {
      _$_SignupTypeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_SignupTypeStoreActionController.startAction(
        name: '_SignupTypeStore.clear');
    try {
      return super.clear();
    } finally {
      _$_SignupTypeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selected: ${selected}
    ''';
  }
}
