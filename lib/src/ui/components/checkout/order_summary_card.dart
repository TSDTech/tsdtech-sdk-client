import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsdtech_client_sdk/models/cart/cart_item.model.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
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
              const Text('Nenhum resumo encontrado para o pedido.')
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
