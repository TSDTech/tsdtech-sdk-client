import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @observable
  bool isPasswordVisible = false;

  @observable
  bool isLoading = false;

  LoginResponseClient? _loginResponse;
  String? _error;

  LoginResponseClient? get loginResponse => _loginResponse;
  String? get error => _error;

  @action
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  // Mock login for now; prepared to call backend later
  @action
  Future<void> login() async {
    isLoading = true;
    _error = null;
    _loginResponse = null;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    await Future.delayed(const Duration(seconds: 1));

    // simple local validation / mock
    if (email == 'test@example.com' && password == 'password') {
      _loginResponse = LoginResponseClient(token: 'mock-token');
      _error = null;
    } else {
      _error = 'Email/CPF ou senha incorretos.';
      _loginResponse = null;
    }

    isLoading = false;
  }

  Future<void> logout() async {
    _loginResponse = null;
    _error = null;
    emailController.clear();
    passwordController.clear();
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}

// Minimal LoginResponseClient used locally to avoid importing full model
class LoginResponseClient {
  final String token;
  LoginResponseClient({required this.token});
}
