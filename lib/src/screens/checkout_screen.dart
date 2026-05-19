import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/cart/cart_item.model.dart';
import '../client/tsdtech-client/tsdtech_client.dart';
import '../services/gateway-services/gateway_service.dart';
import '../ui/checkout/checkout_widget.dart';
import '../ui/checkout/payment_types.dart';
import '../ui/stores/checkout_store.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.items,
    required this.administratorId,
    required this.onSuccess,
    required this.onCancel,
    required this.client,
  });

  final List<CartItem> items;
  final String administratorId;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;
  final TsdtechClient client;

  static MaterialPageRoute<void> route({
    required List<CartItem> items,
    required String administratorId,
    required VoidCallback onSuccess,
    required VoidCallback onCancel,
    required TsdtechClient client,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => CheckoutScreen(
        items: items,
        administratorId: administratorId,
        onSuccess: onSuccess,
        onCancel: onCancel,
        client: client,
      ),
      settings: const RouteSettings(name: 'checkout_screen'),
    );
  }

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutWidgetController _checkoutController =
      CheckoutWidgetController();
  final CheckoutStore _checkoutStore = CheckoutStore();
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R4',
  );

  String _gatewayPublicKey = '';
  bool _isFetchingGatewayPublicKey = false;
  String? _gatewayKeyError;

  GatewayService? get _gatewayService => widget.client.gateway;

  double get _totalValue {
    return widget.items.fold<double>(0, (sum, item) {
      return sum + ((item.service.price ?? 0) * item.quantity);
    });
  }

  @override
  void initState() {
    super.initState();
    _checkoutController.selectedMethod.addListener(_handleMethodChange);
  }

  @override
  void dispose() {
    _checkoutController.selectedMethod.removeListener(_handleMethodChange);
    _checkoutController.dispose();
    _checkoutStore.dispose();
    super.dispose();
  }

  Future<void> _handleMethodChange() async {
    if (_checkoutController.selectedMethod.value == PaymentMethodType.card) {
      await _ensureGatewayPublicKey();
    }
  }

  Future<void> _ensureGatewayPublicKey() async {
    if (_gatewayPublicKey.isNotEmpty || _isFetchingGatewayPublicKey) {
      return;
    }

    final effectiveGatewayService = _gatewayService;

    if (effectiveGatewayService == null) {
      setState(() {
        _gatewayKeyError =
            'Forneca um TsdtechClient com gateway configurado antes do checkout com cartão.';
      });
      return;
    }

    setState(() {
      _isFetchingGatewayPublicKey = true;
      _gatewayKeyError = null;
    });

    final service = effectiveGatewayService;

    final result = await service.fetchPublicKey();
    if (!mounted) {
      return;
    }

    setState(() {
      _isFetchingGatewayPublicKey = false;
      if (result.isSuccess && result.value != null) {
        _gatewayPublicKey = result.value!.pemPublicKey;
        _gatewayKeyError = null;
      } else {
        _gatewayKeyError = result.error.isNotEmpty
            ? result.error
            : 'Nao foi possivel carregar a chave publica do gateway.';
      }
    });
  }

  Future<void> _handlePay() async {
    if (_checkoutController.selectedMethod.value == PaymentMethodType.card) {
      await _ensureGatewayPublicKey();
      if (!mounted || _gatewayPublicKey.isEmpty) {
        if (_gatewayKeyError != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_gatewayKeyError!)));
        }
        return;
      }
    }

    await _checkoutController.submitPayment();
  }

  void _handleCancel() {
    widget.onCancel();
    Navigator.of(context).maybePop();
  }

  String _payButtonLabel() {
    final method = _checkoutController.selectedMethod.value;
    if (method == PaymentMethodType.card) {
      return 'Pagar agora';
    }
    if (_checkoutController.hasGeneratedPix.value) {
      return 'Pagamento PIX gerado';
    }
    return 'Gerar pagamento';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _handleCancel,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _OrderSummaryCard(
                items: widget.items,
                totalValue: _totalValue,
                currencyFormat: _currencyFormat,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Metodo de pagamento',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CheckoutWidget(
                        store: _checkoutStore,
                        controller: _checkoutController,
                        items: widget.items,
                        administratorId: widget.administratorId,
                        gatewayPublicKey: _gatewayPublicKey,
                        showSubmitButton: false,
                        client: widget.client,
                        onSuccess: (_) => widget.onSuccess(),
                      ),
                      if (_gatewayKeyError != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _gatewayKeyError!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: _checkoutController.isLoading,
            builder: (context, isLoading, _) {
              return ValueListenableBuilder<PaymentMethodType>(
                valueListenable: _checkoutController.selectedMethod,
                builder: (context, method, _) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _checkoutController.hasGeneratedPix,
                    builder: (context, hasGeneratedPix, _) {
                      final isDisabled =
                          isLoading ||
                          _isFetchingGatewayPublicKey ||
                          (method == PaymentMethodType.pix && hasGeneratedPix);

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: isDisabled ? null : _handlePay,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              _isFetchingGatewayPublicKey
                                  ? 'Preparando pagamento...'
                                  : _payButtonLabel(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Ao continuar, voce concorda com os termos e com o processamento do pagamento.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({
    required this.items,
    required this.totalValue,
    required this.currencyFormat,
  });

  final List<CartItem> items;
  final double totalValue;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resumo do pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const Text('Nenhum item selecionado.')
            else
              ...items.map((item) {
                final unitValue = item.service.price ?? 0;
                final lineTotal = unitValue * item.quantity;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.service.name ?? 'Servico sem nome',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.quantity} x ${currencyFormat.format(unitValue)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(currencyFormat.format(lineTotal)),
                    ],
                  ),
                );
              }),
            const Divider(height: 24),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  currencyFormat.format(totalValue),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
