import 'package:flutter/material.dart';
import 'payment_types.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethodType? selectedMethod;
  final ValueChanged<PaymentMethodType> onChanged;
  final bool showPix;
  final bool showCard;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
    this.showPix = true,
    this.showCard = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showPix) _buildOption(PaymentMethodType.pix, 'PIX', Icons.qr_code),

        // Adiciona um espaçamento caso os dois botões estejam visíveis
        if (showPix && showCard) const SizedBox(width: 12),

        if (showCard)
          _buildOption(PaymentMethodType.card, 'Cartão', Icons.credit_card),
      ],
    );
  }

  Widget _buildOption(PaymentMethodType type, String title, IconData icon) {
    final isSelected = selectedMethod == type;

    // Enquanto nada foi escolhido, os dois cards ganham destaque para
    // chamar a atenção do usuário; depois só o selecionado fica em evidência.
    final hasSelection = selectedMethod != null;
    final isHighlighted = isSelected || !hasSelection;

    // O mesmo verde utilizado no botão e nos valores da imagem
    const brandGreen = Color(0xFF10C484);

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            // Fundo branco se inativo, e um verde beeem sutil se selecionado
            color: isSelected
                ? brandGreen.withValues(alpha: 0.06)
                : Colors.white,
            border: Border.all(
              // Borda verde se selecionado ou enquanto aguarda a escolha
              color: isHighlighted
                  ? brandGreen.withValues(alpha: isSelected ? 1 : 0.45)
                  : Colors.grey.shade300,
              width: isSelected ? 2 : 1.4,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (isHighlighted)
                BoxShadow(
                  color: brandGreen.withValues(alpha: isSelected ? 0.22 : 0.14),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? brandGreen
                      : brandGreen.withValues(alpha: 0.12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : brandGreen,
                  size: 26,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? brandGreen : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
