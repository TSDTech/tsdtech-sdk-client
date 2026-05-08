import 'package:mobx/mobx.dart';

part 'signup_type_store.g.dart';

enum SignupType { person, company }

class SignupTypeStore = _SignupTypeStore with _$SignupTypeStore;

abstract class _SignupTypeStore with Store {
  @observable
  SignupType? selected;

  @action
  void selectPerson() => selected = SignupType.person;

  @action
  void selectCompany() => selected = SignupType.company;

  @action
  void clear() => selected = null;

  bool get isPerson => selected == SignupType.person;
  bool get isCompany => selected == SignupType.company;
}
