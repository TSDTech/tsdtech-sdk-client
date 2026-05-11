import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/components/nav_header.dart';
import 'package:tsdtech_client_sdk/core/local_storage/client_user_token_data/client_user_token_data.prefs.dart';
import 'package:tsdtech_client_sdk/features/profile_menu/core/profile_menu_store.dart';

@RoutePage()
class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sl = GetIt.instance;
  // Garante que o store seja instanciado corretamente
  final store = sl.isRegistered<ProfileMenuStore>()
    ? sl<ProfileMenuStore>()
    : ProfileMenuStore();

    // Carrega dados do usuário logado ao abrir a tela
    final userData = ClientUserTokenDataPrefs.get();
    if (userData != null && store.name.isEmpty) {
      store.setUserData(
        name: userData.name ?? '',
        secondName: userData.secondName ?? '',
        email: userData.email ?? '',
        phone: userData.phone ?? '',
        cpf: userData.cpf ?? '',
      );
    }

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
                  const Text(
                    'Portal do Cidadão',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tudo mais fácil: escolha o serviço, compre seu voucher e acompanhe seus cupons',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 48),
                      child: Observer(
                        builder: (_) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.person_outline, color: Colors.black54),
                                SizedBox(width: 8),
                                Text('Meu perfil  >  Atualizar meus dados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 32),
                            const Center(
                              child: Text('Atualize suas informações abaixo.', style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Nome*', style: TextStyle(fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: TextEditingController(text: store.name),
                                        onChanged: (v) => store.name = v,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xFFF6F7F9),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Sobrenome*', style: TextStyle(fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: TextEditingController(text: store.secondName),
                                        onChanged: (v) => store.secondName = v,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xFFF6F7F9),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('E-mail*', style: TextStyle(fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: TextEditingController(text: store.email),
                                        onChanged: (v) => store.email = v,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xFFF6F7F9),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Celular*', style: TextStyle(fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: TextEditingController(text: store.phone),
                                        onChanged: (v) => store.phone = v,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xFFF6F7F9),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('CPF*', style: TextStyle(fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: TextEditingController(text: store.cpf),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xFFE5E7EB),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                          suffixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF)),
                                        ),
                                        readOnly: true,
                                      ),
                                      const SizedBox(height: 4),
                                      const Text('CPF não pode ser alterado', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Senha*', style: TextStyle(fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: TextEditingController(text: store.password),
                                        onChanged: (v) => store.password = v,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xFFF6F7F9),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                          suffixIcon: GestureDetector(
                                            onTap: () {},
                                            child: const Icon(Icons.visibility_outlined, color: Color(0xFF9CA3AF)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () {},
                                        child: const Text('Alterar senha', style: TextStyle(fontSize: 12, color: Color(0xFF2563EB), decoration: TextDecoration.underline)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // Mensagem de sucesso
                            //if (false) // Exemplo: exibir após sucesso
                              // Mensagem de sucesso pode ser exibida após updateProfile
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 220,
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // Resetar campos para dados originais
                                      if (userData != null) {
                                        store.setUserData(
                                          name: userData.name ?? '',
                                          secondName: userData.secondName ?? '',
                                          email: userData.email ?? '',
                                          phone: userData.phone ?? '',
                                          cpf: userData.cpf ?? '',
                                        );
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Color(0xFFD32F2F), width: 2),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Cancelar', style: TextStyle(color: Color(0xFFD32F2F), fontSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 32),
                                SizedBox(
                                  width: 220,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await store.updateProfile();
                                      // Exibir mensagem de sucesso futuramente
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF199A4E),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Salvar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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