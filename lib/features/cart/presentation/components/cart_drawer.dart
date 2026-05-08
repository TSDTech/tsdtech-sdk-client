import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:voucherize/features/cart/core/stores/cart_store.dart';
import 'package:voucherize/core/components/ds_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:auto_route/auto_route.dart';
import 'package:voucherize/core/router/router.dart';
import 'package:voucherize/features/cart/presentation/components/cart_empty_dialog.dart';

final _sl = GetIt.instance;

class CartDrawer extends StatefulWidget {
  const CartDrawer({super.key});

  @override
  State<CartDrawer> createState() => _CartDrawerState();
}

class _CartDrawerState extends State<CartDrawer> {
  late final CartStore cart;

  @override
  void initState() {
    super.initState();
    cart = _sl<CartStore>();
    // mark drawer open
    cart.setDrawerOpen(true);
  }

  @override
  void dispose() {
    try {
      cart.setDrawerOpen(false);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Drawer width is fixed-ish; outermost background must be #F4F4F4
    final width = math.max(MediaQuery.of(context).size.width * 0.4, 320.0);
    return SizedBox(
      width: width,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: 0,
        child: Container(
          color: const Color(0xFFF4F4F4),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Container(
                // This container represents the white card that contains the cart
                color: Colors.white, // #FFFFFF
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Header row: title, item count and clean button + close
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const DsText(
                                    text: 'Carrinho de compras',
                                    variant: DsTextVariant.baseBold),
                                const SizedBox(height: 4),
                                Observer(builder: (_) {
                                  final count = cart.items.length;
                                  return DsText(
                                      text: '$count itens',
                                      variant: DsTextVariant.small,
                                      color: const Color(0xFF6B7280));
                                }),
                              ],
                            ),
                          ),
                          // Limpar button
                          TextButton.icon(
                            onPressed: () {
                              cart.clear();
                            },
                            icon: const Icon(Icons.delete_outline,
                                color: Color(0xFFEF4444)),
                            label: const DsText(
                                text: 'Limpar',
                                variant: DsTextVariant.small,
                                color: Color(0xFFEF4444)),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Content
                      Expanded(
                        child: Observer(builder: (_) {
                          final items = cart.items;
                          if (items.isEmpty) {
                            // When cart is empty we close the drawer and show a centered modal dialog
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              try {
                                Navigator.of(context).pop();
                              } catch (_) {}
                              showCartEmptyDialog(context);
                            });

                            // Return an empty placeholder while dialog is opening
                            return const SizedBox.shrink();
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 8),
                            itemCount: items.length,
                            itemBuilder: (ctx, idx) {
                              final it = items[idx];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: const Color(
                                      0xFFF3F4F6), // item card color
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFEFEDED), width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DsText(
                                          text: it.service.name ?? '',
                                          variant: DsTextVariant.smallBold),
                                      const SizedBox(height: 6),
                                      DsText(
                                          text:
                                              'Código: ${it.service.code ?? ''}',
                                          variant: DsTextVariant.small),
                                      const SizedBox(height: 6),
                                      DsText(
                                          text: it.service.description ?? '',
                                          variant: DsTextVariant.small,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 10),
                                      Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: (it.service.tags ?? [])
                                              .take(3)
                                              .map((t) => _buildChip(t))
                                              .toList()),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const DsText(
                                                  text: 'Quantidade:',
                                                  variant: DsTextVariant.small),
                                              const SizedBox(height: 6),
                                              Observer(builder: (_) {
                                                return Row(children: [
                                                  _smallRoundButton(
                                                      '-',
                                                      () => cart.decrement(
                                                          it.service)),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xFFE5E7EB))),
                                                    child: DsText(
                                                        text:
                                                            '${cart.quantityOf(it.service)}',
                                                        variant: DsTextVariant
                                                            .baseBold),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  _smallRoundButton(
                                                      '+',
                                                      () => cart.increment(
                                                          it.service)),
                                                ]);
                                              }),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              DsText(
                                                  text:
                                                      'R\$ ${(it.service.price ?? 0.0).toStringAsFixed(2)}',
                                                  variant:
                                                      DsTextVariant.baseBold,
                                                  color:
                                                      const Color(0xFF10B981)),
                                              const SizedBox(height: 6),
                                              const DsText(
                                                  text: 'Por unidade',
                                                  variant: DsTextVariant.small,
                                                  color:
                                                      Color(0xFF6B7280)),
                                              const SizedBox(height: 8),
                                              IconButton(
                                                  onPressed: () {
                                                    cart.remove(it.service);
                                                  },
                                                  icon: const Icon(
                                                      Icons.delete_outline,
                                                      color:
                                                          Color(0xFFEF4444))),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),

                      // Bottom total area with background #F3F4F6
                      Container(
                        color: const Color(0xFFF3F4F6),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const DsText(
                                    text: 'Total:',
                                    variant: DsTextVariant.baseBold),
                                Observer(
                                    builder: (_) => DsText(
                                        text:
                                            'R\$ ${cart.total.toStringAsFixed(2)}',
                                        variant: DsTextVariant.baseBold,
                                        color: const Color(0xFF10B981))),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                AutoRouter.of(context).push(CheckoutRoute());
                              },
                              icon: const Icon(Icons.shopping_cart,
                                  color: Colors.white),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: DsText(
                                    text: 'Finalizar compra',
                                    variant: DsTextVariant.baseBold,
                                    color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const DsText(
                                    text: 'Continuar comprando',
                                    variant: DsTextVariant.small,
                                    color: Color(0xFF2563EB))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE6EEF9))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DsText(
              text: text,
              variant: DsTextVariant.small,
              color: const Color(0xFF1E3A8A)),
        ],
      ),
    );
  }

  Widget _smallRoundButton(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB))),
        child: DsText(text: label, variant: DsTextVariant.baseBold),
      ),
    );
  }
}
