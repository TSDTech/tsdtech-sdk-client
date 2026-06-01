import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsdtech_client_sdk/models/cart/cart_item.model.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.items,
    required this.totalValue,
    required this.currencyFormat,
  });

  final List<CartItem> items;
  final double totalValue;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    // Cor verde baseada na imagem
    const brandGreen = Color(0xFF10C484); 

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Descrição do carrinho',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600, 
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const Text('Nenhum serviço no carrinho.')
            else
              ...items.map((item) {
                final unitValue = item.service.price ?? 0;
                
                // Fallback de descrição para ficar igual à imagem caso seu model
                // não tenha a propriedade description no momento.
                final description = item.service.description?.toLowerCase() ?? 'Sem descrição';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F7), // Fundo cinza claro
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.service.name ?? 'Serviço sem nome',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currencyFormat.format(unitValue),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: brandGreen,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Qtd: ${item.quantity}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            
            const SizedBox(height: 8),
            
            // Rodapé do Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16, 
                    color: Colors.black87,
                  ),
                ),
                Text(
                  currencyFormat.format(totalValue),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: brandGreen,
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
