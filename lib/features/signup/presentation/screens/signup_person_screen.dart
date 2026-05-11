import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tsdtech_client_sdk/core/components/ds_button.dart';
import 'package:tsdtech_client_sdk/core/components/ds_fullscreen_loader.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/core/components/ds_textfield.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';
import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/features/signup/core/stores/signup_person_store.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-authorizers/client-users/auth_service.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';

@RoutePage()
class SignupPersonScreen extends StatelessWidget {
  const SignupPersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.instance<SignupPersonStore>();

    Future<void> submit() async {
      FocusScope.of(context).unfocus();

      final dto = store.buildDto();

      if (dto.firstName.isEmpty || dto.email.isEmpty || dto.password.isEmpty || dto.cellphone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, preencha os campos obrigatórios.'), backgroundColor: Colors.redAccent));
        return;
      }

      final overlay = OverlayEntry(builder: (_) => const DsFullscreenLoader());
      Overlay.of(context).insert(overlay);

      try {
        final ValueResult result = await AuthServiceClientUser.instance.signup(dto);
        overlay.remove();

        if (result.isSuccess && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conta criada com sucesso.'), backgroundColor: Colors.green));
          context.router.replace(const HomeRoute());
        } else if (context.mounted) {
          final err = result.isError ? result.error : 'Erro ao cadastrar.';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err), backgroundColor: Colors.redAccent));
        }
      } catch (e) {
        overlay.remove();
        final vr = ValueResult.fromError(e);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vr.error), backgroundColor: Colors.redAccent));
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF3E6BF7),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: Image.asset('assets/detran-logo.png', width: 150, height: 150)),
                  const SizedBox(height: 12),
                  const DsText(text: 'Faça seu cadastro', variant: DsTextVariant.debtValueLarge, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const DsText(text: 'Preencha os dados abaixo para criar sua conta.', variant: DsTextVariant.base, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: DsTextfield(controller: store.firstNameController, hintText: 'Nome')),
                      const SizedBox(width: 12),
                      Expanded(child: DsTextfield(controller: store.lastNameController, hintText: 'Sobrenome')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: DsTextfield(controller: store.emailController, hintText: 'E-mail')),
                      const SizedBox(width: 12),
                      Expanded(child: DsTextfield(controller: store.cellphoneController, hintText: 'Celular')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: DsTextfield(controller: store.documentController, hintText: 'CPF')),
                      const SizedBox(width: 12),
                      Expanded(child: DsTextfield(controller: store.passwordController, hintText: 'Senha', obscureText: true)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DsButton(onPressed: submit, text: 'Cadastrar-se', width: double.infinity, variant: DsButtonVariant.primarySignUp),
                  const SizedBox(height: 12),
                  Center(child: TextButton(onPressed: () => context.router.replace(LoginRoute()), child: const DsText(text: 'Já tem uma conta? Faça Login', variant: DsTextVariant.smallBold))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
