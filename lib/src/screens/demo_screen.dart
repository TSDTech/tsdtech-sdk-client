import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tsdtech_client_sdk/src/ui/components/demo/demo_components.dart';
import 'package:tsdtech_client_sdk/src/utils/mocks/mock_item_generator.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  // ==========================================
  // STORES OFICIAIS DO SDK (Nenhuma store mockada)
  // ==========================================
  final CheckoutStore _checkoutStore = CheckoutStore();
  final PaymentStore _paymentStore = PaymentStore();
  final CardFormStore _cardFormStore = CardFormStore();

  // Estado local para a visualização na demo
  PaymentFormData? _paymentFormResult;
  CardFormData? _cardPreview;
  PaymentStatus? _checkoutStatus;
  bool _isDarkTheme = false;

  static const _administratorId = 'admin_demo_123';

  // Agora nossa lista começa vazia e será preenchida aleatoriamente
  List<CartItem> _demoItems = [];

  @override
  void initState() {
    super.initState();
    // Gerando 3 itens aleatórios ao abrir a tela
    _demoItems = MockItemGenerator.generateRandomItems(
      count: 3, 
      administratorId: _administratorId,
    );
  }

  double get _total => _demoItems.fold<double>(
    0,
    (sum, item) => sum + (item.service.price ?? 0) * item.quantity,
  );

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openCheckoutScreen() async {
    await Navigator.of(context).push(
      CheckoutScreen.route(
        items: _demoItems,
        administratorId: _administratorId,
        onSuccess: () => _showMessage('CheckoutScreen concluiu o fluxo.'),
        onCancel: () => _showMessage('CheckoutScreen encerrada pelo usuário.'),
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
      TsdtechUiConfig.initialize(
        baseUrl: TsdtechUiConfig.instance.baseUrl,
        gatewayBaseUrl: TsdtechUiConfig.instance.gatewayBaseUrl,
        apiKey: TsdtechUiConfig.instance.apiKey,
        locale: TsdtechUiConfig.instance.locale,
        theme: _isDarkTheme
            ? TsdtechThemeData.dark()
            : TsdtechThemeData.light(),
      );
    });
  }

  @override
  void dispose() {
    _checkoutStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final theme = TsdtechUiConfig.instance.theme;
        // final isWide = MediaQuery.sizeOf(context).width >= 980;

        return Scaffold(
          appBar: AppBar(title: const Text('TSDTech SDK Example')),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [theme.backgroundColor, theme.surfaceVariantColor],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroSection(theme),
                    const SizedBox(height: 20),
                    _buildWidgetDemoSection(),
                    const SizedBox(height: 20),
                    _buildScreenDemoSection(),
                    const SizedBox(height: 50),
                    // if (isWide)
                    //   Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Expanded(child: _buildStandaloneFormsSection()),
                    //       const SizedBox(width: 20),
                    //       Expanded(child: _buildThemeSection(theme)),
                    //     ],
                    //   )
                    // else
                    //   Column(
                    //     children: [
                    //       _buildStandaloneFormsSection(),
                    //       const SizedBox(height: 20),
                    //       _buildThemeSection(theme),
                    //     ],
                    //   ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroSection(TsdtechThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.borderRadius + 6),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primaryColor, theme.primaryLightColor],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exemplo completo do SDK',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: theme.textOnPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Este app reúne o CheckoutWidget, a CheckoutScreen, os formulários isolados e a troca de tema em uma única vitrine executável.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: theme.textOnPrimaryColor.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              HeroMetric(label: 'Itens', value: '${_demoItems.length}'),
              HeroMetric(
                label: 'Total demo',
                value: 'R\$ ${_total.toStringAsFixed(2)}',
              ),
              HeroMetric(label: 'Tema', value: _isDarkTheme ? 'Dark' : 'Light'),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: _openCheckoutScreen,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.textOnPrimaryColor,
                  foregroundColor: theme.primaryDarkColor,
                ),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Abrir fluxo em tela cheia'),
              ),
              OutlinedButton.icon(
                onPressed: _toggleTheme,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.textOnPrimaryColor,
                  side: BorderSide(
                    color: theme.textOnPrimaryColor.withOpacity(0.4),
                  ),
                ),
                icon: const Icon(Icons.palette_outlined),
                label: const Text('Trocar tema'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetDemoSection() {
    return SectionCard(
      title: 'Uso básico com CheckoutWidget',
      subtitle: 'Exibe o widget direto no layout da sua app.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CheckoutWidget(
            // store: _checkoutStore,
            items: _demoItems,
            administratorId: _administratorId,
            
            // A publicKey foi removida, pois o orquestrador cuida disso!
            onStatusChange: (s) => setState(() => _checkoutStatus = s),
            onSuccess: (result) =>
                _showMessage('Pagamento finalizado: ${result.transactionId}'),
            onError: (message) => _showMessage('Erro: $message'),
          ),
          const SizedBox(height: 16),
          // StatusBanner(status: _checkoutStatus),
        ],  
      ),
    );
  }

  Widget _buildScreenDemoSection() {
    return SectionCard(
      title: 'Uso de telas com CheckoutScreen',
      subtitle: 'Abre o fluxo completo em uma rota dedicada.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FeatureChip(label: 'Navegação pronta'),
              FeatureChip(label: 'Resumo do pedido'),
              FeatureChip(label: 'Controle de loading'),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _openCheckoutScreen,
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Abrir CheckoutScreen'),
          ),
        ],
      ),
    );
  }
}