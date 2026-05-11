import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/components/ds_button.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/core/components/ds_textfield.dart';
import 'package:tsdtech_client_sdk/features/login/core/stores/login_store.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';

@RoutePage()
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginStore = GetIt.instance<LoginStore>();

    Future<void> send() async {
      final email = loginStore.emailController.text.trim();
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, informe o e-mail cadastrado.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // Aqui você chamaria o endpoint de recovery; por enquanto mostra um snackbar
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Se o e-mail estiver cadastrado, você receberá um link.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF3E6BF7),
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
                            child: Image.asset('assets/detran-logo.png'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const DsText(
                          text: 'Sistema Público de Arrecadação',
                          variant: DsTextVariant.baseBold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        const DsText(
                          text: 'Esqueceu sua senha?',
                          variant: DsTextVariant.debtValueLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: DsText(
                            text:
                                'Digite o e-mail cadastrado para receber o link de redefinição.',
                            variant: DsTextVariant.base,
                            textAlign: TextAlign.center,
                          ),
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
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 24),
                        DsButton(
                          onPressed: send,
                          text: 'Enviar',
                          width: double.infinity,
                          variant: DsButtonVariant.primarySignUp,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () =>
                                context.router.replace(LoginRoute()),
                            child: const DsText(
                                text: 'Voltar ao Login',
                                variant: DsTextVariant.smallBold),
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
