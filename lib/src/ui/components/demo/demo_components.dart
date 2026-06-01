// ============================================================================
// COMPONENTES PRIVADOS DA DEMO (Não poluem as pastas do SDK)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/models/cart/cart_item.model.dart';
import 'package:tsdtech_client_sdk/src/ui/checkout/checkout.dart';
import 'package:tsdtech_client_sdk/src/ui/config/tsdtech_ui_config.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = TsdtechUiConfig.instance.theme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: theme.textSecondaryColor),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class CartPreview extends StatelessWidget {
  const CartPreview({required this.items, required this.total});
  final List<CartItem> items;
  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = TsdtechUiConfig.instance.theme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surfaceVariantColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
      ),
      child: Column(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // O nome volta a ficar limpo sozinho
                        Text(
                          item.service.name ?? 'Serviço',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (item.service.description != null)
                          Text(
                            item.service.description!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  // AQUI ESTÁ A MUDANÇA: Quantidade e Valor unitário agrupados
                  Text(
                    '${item.quantity}x R\$ ${(item.service.price ?? 0).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  // Valor total do item isolado à direita
                  Text(
                    'R\$ ${((item.service.price ?? 0) * item.quantity).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          const Divider(height: 24),
          Row(
            children: [
              const Expanded(child: Text('Total do carrinho demo')),
              Text(
                'R\$ ${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

<<<<<<< Updated upstream
class StatusBanner extends StatelessWidget {
  const StatusBanner({required this.status});
  final PaymentStatus? status;

  @override
  Widget build(BuildContext context) {
    final theme = TsdtechUiConfig.instance.theme;
    if (status == null) {
      return const InfoTile(
        title: 'Status do CheckoutWidget',
        content: 'Aguardando ação.',
      );
    }


    final map = switch (status!) {
      PaymentStatus.processing => ('Processando', theme.warningColor),
      PaymentStatus.waitingPayment => (
        'Aguardando pagamento',
        theme.accentColor,
      ),
      PaymentStatus.success => ('Concluído', theme.successColor),
      PaymentStatus.failed => ('Falhou', theme.errorColor),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: map.$2.withOpacity(0.12),
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: map.$2.withOpacity(0.32)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: map.$2),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Status atual: ${map.$1}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

=======
>>>>>>> Stashed changes
class InfoTile extends StatelessWidget {
  const InfoTile({required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = TsdtechUiConfig.instance.theme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surfaceVariantColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: theme.outlineColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(content, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class FeatureChip extends StatelessWidget {
  const FeatureChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

class HeroMetric extends StatelessWidget {
  const HeroMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = TsdtechUiConfig.instance.theme;
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: theme.textOnPrimaryColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: theme.textOnPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class PaletteRow extends StatelessWidget {
  const PaletteRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class ColorSwatchCard extends StatelessWidget {
  const ColorSwatchCard({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 10),
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}