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

        // Adiciona um espaçamento caso os dois botões estejam visíveis
        if (showPix && showCard) const SizedBox(width: 12),

        //TODO - implementar cartão
        // if (showCard)
        //   _buildOption(PaymentMethodType.card, 'Cartão', Icons.credit_card),
      ],
    );
  }

  Widget _buildOption(PaymentMethodType type, String title, IconData icon) {
    final isSelected = selectedMethod == type;

    // O mesmo verde utilizado no botão e nos valores da imagem
    const brandGreen = Color(0xFF10C484);

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            // Fundo branco se inativo, e um verde beeem sutil se selecionado
            color: isSelected
                ? brandGreen.withValues(alpha: 0.05)
                : Colors.white,
            border: Border.all(
              // Borda verde se selecionado, senão borda cinza clara
              color: isSelected ? brandGreen : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? brandGreen : Colors.black54,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? brandGreen : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
