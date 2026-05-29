import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart'; // Puxando do seu barrel file

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O app cliente que usa seu SDK vai instanciar a store oficial de vocês
  final CheckoutStore _checkoutStore = CheckoutStore();

  static const String _administratorId = 'admin_123';
  static const String _gatewayPublicKey = '''-----BEGIN PUBLIC KEY-----
Sua chave publica aqui
-----END PUBLIC KEY-----''';

  // Simulação de itens adicionados ao carrinho
  final List<CartItem> _items = [
    CartItem(
      service: Service(
        id: 'svc_123',
        name: 'Serviço Oficial TSDTech',
        price: 150.00,
        administratorId: _administratorId,
      ),
      quantity: 1,
    ),
  ];

  @override
  void dispose() {
    _checkoutStore.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste de Integração SDK')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'CheckoutWidget Drop-in',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Aqui entra o componente oficial do seu SDK usando a store real
            CheckoutWidget(
              store: _checkoutStore,
              items: _items,
              administratorId: _administratorId,
              gatewayPublicKey: _gatewayPublicKey,
              onStatusChange: (status) {
                // ignore: avoid_print
                print('Status mudou para: $status');
              },
              onSuccess: (result) {
                _showMessage(
                  'Pagamento ${result.method.name} finalizado!\nID: ${result.transactionId}',
                );
              },
              onError: (error) {
                _showMessage('Erro no pagamento: $error');
              },
            ),
          ],
        ),
      ),
    );
  }
}
