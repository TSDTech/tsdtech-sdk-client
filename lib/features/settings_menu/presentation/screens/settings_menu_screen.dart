import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/core/components/nav_header.dart';
import 'package:tsdtech_client_sdk/features/settings_menu/presentation/components/settings_card.dart';
import 'package:tsdtech_client_sdk/features/settings_menu/presentation/components/settings_link.dart';

@RoutePage()
class SettingsMenuScreen extends StatelessWidget {
  const SettingsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavHeader(),
      backgroundColor: const Color(0xFFF6F7F9),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const DsText(
                    text: 'Portal do Cidadão',
                    variant: DsTextVariant.titleVoucher,
                  ),
                  const SizedBox(height: 4),
                  const DsText(
                    text:
                        'Tudo mais fácil: escolha o serviço, compre seu voucher e acompanhe seus cupons',
                    variant: DsTextVariant.textVoucher,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        const BoxShadow(color: Colors.black12, blurRadius: 8)
                      ],
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_outline, color: Colors.black54),
                              SizedBox(width: 8),
                              DsText(
                                  text: 'Meu perfil  >  Configurações',
                                  variant: DsTextVariant.baseBold),
                            ],
                          ),
                          SizedBox(height: 32),
                          // Card: Conta e Segurança
                          SettingsCard(
                            title: 'Conta e Segurança',
                            links: [
                              SettingsLink('Alterar senha'),
                            ],
                          ),
                          SizedBox(height: 18),
                          // Card: Preferências do Usuário
                          SettingsCard(
                            title: 'Preferências do Usuário',
                            links: [
                              SettingsLink('Idioma'),
                              SettingsLink('Notificações'),
                            ],
                          ),
                          SizedBox(height: 18),
                          // Card: Privacidade
                          SettingsCard(
                            title: 'Privacidade',
                            links: [
                              SettingsLink('Termos de Uso'),
                              SettingsLink('Política de Privacidade'),
                              SettingsLink('Excluir conta'),
                            ],
                          ),
                          SizedBox(height: 18),
                          // Card: Suporte
                          SettingsCard(
                            title: 'Suporte',
                            links: [
                              SettingsLink('Alterar senha'),
                            ],
                          ),
                        ],
                      ),
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
