import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:voucherize/core/local_storage/administrator/administrator_id.prefs.dart';
import 'package:voucherize/models/auth/signup-request-client.model.dart';


part 'signup_person_store.g.dart';

class SignupPersonStore = _SignupPersonStore with _$SignupPersonStore;

abstract class _SignupPersonStore with Store {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final cellphoneController = TextEditingController();
  final documentController = TextEditingController();
  final passwordController = TextEditingController();

  @observable
  bool isLoading = false;

  @observable
  String? error;

  SignupRequestClient buildDto() {
    return SignupRequestClient(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      document: documentController.text.trim(),
      cellphone: cellphoneController.text.trim(),
      documentType: 'CPF',
      administratorId: AdministratorIdPrefs.get()!,
    );
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    cellphoneController.dispose();
    documentController.dispose();
    passwordController.dispose();
  }
}
