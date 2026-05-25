import 'package:flutter/material.dart';
import 'payment_types.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethodType selectedMethod;
  final ValueChanged<PaymentMethodType> onChanged;
  final bool showPix;
  final bool showCard;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
    this.showPix = true,
    this.showCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showPix) _buildOption(PaymentMethodType.pix, 'PIX', Icons.qr_code),
        //TODO - implementar cartão
        // if (showCard)
        //   _buildOption(PaymentMethodType.card, 'Cartão', Icons.credit_card),
      ],
    );
  }

  Widget _buildOption(PaymentMethodType type, String title, IconData icon) {
    final isSelected = selectedMethod == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.withValues(alpha: 0.1)
                : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
