import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:voucherize/core/services/intra-api/md-authorizers/client-users/auth_service.dart';
import 'package:voucherize/models/value_result.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @observable
  bool isLoading = false;

  @observable
  bool isPasswordVisible = false;

  @observable
  bool rememberMe = false;

  @observable
  String? error;

  /// Successful login response placeholder. Kept simple to avoid tight coupling.
  @observable
  dynamic loginResponse;

  @action
  void clearError() => error = null;

  @action
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  @action
  void setRememberMe(bool value) {
    rememberMe = value;
  }

  @action
  Future<void> login() async {
    isLoading = true;
    error = null;
    loginResponse = null;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final ValueResult result = await AuthServiceClientUser.instance.login(
        email: email,
        password: password,
      );

      if (result.isSuccess) {
        loginResponse = result.value;
      } else {
        error = result.error;
      }
    } catch (e) {
      final vr = ValueResult.fromError(e);
      error = vr.error;
    } finally {
      isLoading = false;
    }
  }

  Future<void> dispose() async {
    emailController.dispose();
    passwordController.dispose();
  }
}
