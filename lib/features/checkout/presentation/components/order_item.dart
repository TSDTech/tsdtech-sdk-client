import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/models/cart/cart_item.model.dart';

class OrderItem extends StatelessWidget {
  final CartItem item;
  const OrderItem({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final service = item.service;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              DsText(text: service.name ?? '', variant: DsTextVariant.smallBold),
              const SizedBox(height: 6),
              DsText(text: service.description ?? '', variant: DsTextVariant.small, maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            DsText(text: 'R\$ ${(service.price ?? 0.0).toStringAsFixed(2)}', variant: DsTextVariant.baseBold, color: const Color(0xFF10B981)),
            const SizedBox(height: 6),
            DsText(text: 'Qtd: ${item.quantity}', variant: DsTextVariant.small),
          ])
        ],
      ),
    );
  }
}
