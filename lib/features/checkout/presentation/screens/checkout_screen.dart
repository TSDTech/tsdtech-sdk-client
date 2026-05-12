import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tsdtech_client_sdk/core/components/nav_header.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';
import 'package:tsdtech_client_sdk/features/cart/core/stores/cart_store.dart';
import 'package:tsdtech_client_sdk/features/checkout/presentation/components/order_item.dart';
import 'package:tsdtech_client_sdk/features/checkout/core/stores/checkout_store.dart';
import 'package:tsdtech_client_sdk/features/checkout/core/models/payment_method.dart';
import 'package:tsdtech_client_sdk/features/checkout/presentation/components/payment_pix.dart';
import 'package:tsdtech_client_sdk/features/checkout/presentation/components/payment_card.dart';
import 'package:tsdtech_client_sdk/features/checkout/presentation/components/payment_boleto.dart';
import 'package:tsdtech_client_sdk/features/checkout/presentation/components/payment_option_tile.dart';

@RoutePage()
class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  static const double _mobileBreakpoint = 900;

  @override
  Widget build(BuildContext context) {
    final cart = GetIt.instance<CartStore>();
    final checkout = GetIt.instance<CheckoutStore>();
    final isMobile = MediaQuery.of(context).size.width < _mobileBreakpoint;

    return Scaffold(
      appBar: const NavHeader(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const DsText(
                      text: 'Finalizar compra',
                      variant: DsTextVariant.mediumTitle),
                  const SizedBox(height: 8),
                  const DsText(
                      text: 'Resumo do pedido e forma de pagamento',
                      variant: DsTextVariant.normal),
                  const SizedBox(height: 24),

                  // Main card area: two columns
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          const BoxShadow(color: Colors.black12, blurRadius: 8)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildOrderSummary(cart, checkout),
                                const SizedBox(height: 24),
                                _buildPaymentSection(context, cart, checkout),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: _buildOrderSummary(cart, checkout),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 1,
                                  child: _buildPaymentSection(
                                      context, cart, checkout),
                                ),
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartStore cart, CheckoutStore checkout) {
    return Observer(builder: (_) {
      final items = cart.items;
      if (items.isEmpty) {
        return const SizedBox.shrink();
      }

      // Keep summary with content-driven height.
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DsText(
              text: 'Resumo do pedido', variant: DsTextVariant.baseBold),
          const SizedBox(height: 12),
          ...items.map((it) => OrderItem(item: it)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const DsText(text: 'Total', variant: DsTextVariant.baseBold),
            Observer(
                builder: (_) => DsText(
                    text: 'R\$ ${checkout.total.toStringAsFixed(2)}',
                    variant: DsTextVariant.baseBold,
                    color: const Color(0xFF10B981))),
          ])
        ],
      );
    });
  }

  Widget _buildPaymentSection(
      BuildContext context, CartStore cart, CheckoutStore checkout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Observer(builder: (_) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.credit_card, size: 20, color: Color(0xFF2563EB)),
                    SizedBox(width: 8),
                    DsText(
                        text: 'Forma de pagamento',
                        color: Color.fromRGBO(17, 24, 39, 1),
                        variant: DsTextVariant.baseBold),
                  ],
                ),
                const SizedBox(height: 12),
                PaymentOptionTile(
                  value: PaymentMethod.pix,
                  groupValue: checkout.selectedPayment,
                  onChanged: (v) => checkout.selectPayment(v!),
                  title: 'Pix',
                  subtitle: 'Pagamento instantâneo',
                  icon: Icons.qr_code_2,
                  contentWhenSelected: const PaymentPix(),
                ),
                const SizedBox(height: 8),
                PaymentOptionTile(
                  value: PaymentMethod.card,
                  groupValue: checkout.selectedPayment,
                  onChanged: (v) => checkout.selectPayment(v!),
                  title: 'Cartão de crédito',
                  subtitle: 'Parcelamento disponível',
                  icon: Icons.credit_card,
                  contentWhenSelected: PaymentCard(
                    onChanged: checkout.setCardPaymentInput,
                  ),
                ),
                const SizedBox(height: 8),
                PaymentOptionTile(
                  value: PaymentMethod.boleto,
                  groupValue: checkout.selectedPayment,
                  onChanged: (v) => checkout.selectPayment(v!),
                  title: 'Boleto/GRU',
                  subtitle: 'Vencimento em até 3 dias úteis',
                  icon: Icons.receipt_long,
                  contentWhenSelected: const PaymentBoleto(),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
        Observer(builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (checkout.selectedPayment != PaymentMethod.pix &&
                  checkout.selectedPayment != PaymentMethod.boleto)
                _buildCardCheckoutButton(context, cart, checkout),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildCardCheckoutButton(
      BuildContext context, CartStore cart, CheckoutStore checkout) {
    return Observer(builder: (_) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: checkout.isProcessing ? Colors.blue : const Color(0xFF10B981),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ElevatedButton(
          onPressed: (cart.items.isEmpty || checkout.isProcessing)
              ? null
              : () async {
                  try {
                    final result =
                        await checkout.createCheckout(encryptedCard: null);
                    if (result.isSuccess) {
                      AutoRouter.of(context)
                          .replaceAll([const PurchaseHistoryRoute()]);
                      cart.clear();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Checkout criado com sucesso!')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Erro ao criar checkout: ${result.error}')));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro inesperado: $e')));
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: DsText(
            text: checkout.isProcessing
                ? 'Processando...'
                : 'Confirmar pagamento',
            variant: DsTextVariant.baseBold,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  // itemsAreEmpty helper removed: use cart.items.isEmpty directly where needed
}
