// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_menu_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileMenuStore on _ProfileMenuStore, Store {
  late final _$nameAtom =
      Atom(name: '_ProfileMenuStore.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$secondNameAtom =
      Atom(name: '_ProfileMenuStore.secondName', context: context);

  @override
  String get secondName {
    _$secondNameAtom.reportRead();
    return super.secondName;
  }

  @override
  set secondName(String value) {
    _$secondNameAtom.reportWrite(value, super.secondName, () {
      super.secondName = value;
    });
  }

  late final _$emailAtom =
      Atom(name: '_ProfileMenuStore.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: '_ProfileMenuStore.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$phoneAtom =
      Atom(name: '_ProfileMenuStore.phone', context: context);

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  late final _$cpfAtom = Atom(name: '_ProfileMenuStore.cpf', context: context);

  @override
  String get cpf {
    _$cpfAtom.reportRead();
    return super.cpf;
  }

  @override
  set cpf(String value) {
    _$cpfAtom.reportWrite(value, super.cpf, () {
      super.cpf = value;
    });
  }

  late final _$updateProfileAsyncAction =
      AsyncAction('_ProfileMenuStore.updateProfile', context: context);

  @override
  Future<void> updateProfile() {
    return _$updateProfileAsyncAction.run(() => super.updateProfile());
  }

  late final _$_ProfileMenuStoreActionController =
      ActionController(name: '_ProfileMenuStore', context: context);

  @override
  void setUserData(
      {required String name,
      required String secondName,
      required String email,
      required String phone,
      required String cpf}) {
    final _$actionInfo = _$_ProfileMenuStoreActionController.startAction(
        name: '_ProfileMenuStore.setUserData');
    try {
      return super.setUserData(
          name: name,
          secondName: secondName,
          email: email,
          phone: phone,
          cpf: cpf);
    } finally {
      _$_ProfileMenuStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
secondName: ${secondName},
email: ${email},
password: ${password},
phone: ${phone},
cpf: ${cpf}
    ''';
  }
}
