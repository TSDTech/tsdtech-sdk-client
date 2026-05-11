import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/features/checkout/core/models/payment_method.dart';

/// Tile de opção de pagamento com container estilizado, ícone e título/subtítulo.
/// Quando selecionado, exibe [contentWhenSelected] dentro do mesmo container.
class PaymentOptionTile extends StatelessWidget {
  final PaymentMethod value;
  final PaymentMethod? groupValue;
  final ValueChanged<PaymentMethod?> onChanged;
  final String title;
  final String subtitle;
  final IconData icon;

  /// Exibido dentro do tile quando esta opção está selecionada (ex: PaymentPix, PaymentCard).
  final Widget? contentWhenSelected;

  const PaymentOptionTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.contentWhenSelected,
  });

  static const Color _subtitleColor = Color.fromRGBO(107, 114, 128, 1);

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(5),
        border:
            Border.all(width: 1, color: const Color.fromRGBO(231, 229, 228, 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RadioListTile<PaymentMethod>(
            value: value,
            groupValue: groupValue,
            onChanged: (v) => onChanged(v),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DsText(
                              text: title,
                              variant: DsTextVariant.baseBoldMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: _subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isSelected && contentWhenSelected != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: contentWhenSelected,
            ),
          ],
        ],
      ),
    );
  }
}
