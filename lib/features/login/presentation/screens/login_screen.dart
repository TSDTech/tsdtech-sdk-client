import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/components/ds_button.dart';
import 'package:tsdtech_client_sdk/core/components/ds_fullscreen_loader.dart';
import 'package:tsdtech_client_sdk/features/login/core/stores/login_store.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/core/components/ds_textfield.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key, @QueryParam('termsToken') this.termsToken});

  final String? termsToken;
  final loginStore = GetIt.instance<LoginStore>();

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      FocusScope.of(context).unfocus();

      final email = loginStore.emailController.text.trim();
      final password = loginStore.passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, preencha o e-mail e a senha.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // Use loginStore to perform actual login
      loginStore.clearError();
      final overlay = OverlayEntry(builder: (_) => const DsFullscreenLoader());
      Overlay.of(context).insert(overlay);

      await loginStore.login();
      overlay.remove();

      if (loginStore.loginResponse != null && context.mounted) {
        context.router.replace(const HomeRoute());
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loginStore.error?.isNotEmpty == true
                ? loginStore.error!
                : 'Email/CPF ou senha incorretos.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFF3E6BF7), // page background to match image surround
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 64),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back to home button in the top-right corner
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 12, right: 12),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        tooltip: 'Voltar para a home',
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (context.mounted) {
                            context.router.replace(const HomeRoute());
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3E6BF7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset('assets/detran-logo.png')),
                        ),
                        const SizedBox(height: 12),
                        const DsText(
                          text: 'Sistema Público de Arrecadação',
                          variant: DsTextVariant.baseBold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const DsText(
                          text: 'DETRAN-DF • Portal Oficial',
                          variant: DsTextVariant.small,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        const DsText(
                          text: 'Bem-vindo',
                          variant: DsTextVariant.debtValueLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const DsText(
                          text: 'Faça seu login',
                          variant: DsTextVariant.base,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DsText(
                            text: 'E-mail', variant: DsTextVariant.baseBold),
                        const SizedBox(height: 8),
                        DsTextfield(
                          controller: loginStore.emailController,
                          hintText: 'Digite seu e-mail',
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        const SizedBox(height: 16),
                        const DsText(
                            text: 'Senha', variant: DsTextVariant.baseBold),
                        const SizedBox(height: 8),
                        Observer(
                          builder: (_) => DsTextfield(
                            controller: loginStore.passwordController,
                            hintText: 'Digite sua senha',
                            obscureText: !loginStore.isPasswordVisible,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => login(),
                            suffixIcon: IconButton(
                              icon: Icon(loginStore.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: loginStore.togglePasswordVisibility,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Observer(
                                  builder: (_) => Checkbox(
                                    value: loginStore.rememberMe,
                                    onChanged: (v) =>
                                        loginStore.setRememberMe(v ?? false),
                                  ),
                                ),
                                const DsText(
                                    text: 'Lembre de mim',
                                    variant: DsTextVariant.small),
                              ],
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.router.push(ForgotPasswordRoute()),
                              child: const DsText(
                                  text: 'Esqueci minha senha',
                                  variant: DsTextVariant.smallBold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DsButton(
                          onPressed: login,
                          text: 'Login',
                          width: double.infinity,
                          variant: DsButtonVariant.primarySignUp,
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const DsText(
                                  text: 'Não tem conta?',
                                  variant: DsTextVariant.small),
                              TextButton(
                                  onPressed: () => context.router.push(
                                        const SignupPersonRoute(),
                                      ),
                                  child: const DsText(
                                    text: 'Cadastre-se',
                                    variant: DsTextVariant.smallBold,
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
