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
        if (showPix)
          Expanded(
            child: _PaymentOptionCard(
              isSelected: selectedMethod == PaymentMethodType.pix,
              hasSelection: selectedMethod != null,
              title: 'PIX',
              icon: Icons.qr_code,
              onTap: () => onChanged(PaymentMethodType.pix),
            ),
          ),

        // Adiciona um espaçamento caso os dois botões estejam visíveis
        if (showPix && showCard) const SizedBox(width: 12),

        if (showCard)
          Expanded(
            child: _PaymentOptionCard(
              isSelected: selectedMethod == PaymentMethodType.card,
              hasSelection: selectedMethod != null,
              title: 'Cartão',
              icon: Icons.credit_card,
              onTap: () => onChanged(PaymentMethodType.card),
            ),
          ),
      ],
    );
  }
}

class _PaymentOptionCard extends StatefulWidget {
  final bool isSelected;
  final bool hasSelection;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.isSelected,
    required this.hasSelection,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_PaymentOptionCard> createState() => _PaymentOptionCardState();
}

class _PaymentOptionCardState extends State<_PaymentOptionCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  // O mesmo verde utilizado no botão e nos valores da imagem
  static const brandGreen = Color(0xFF10C484);

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    // Enquanto nada foi escolhido, os dois cards ganham destaque para
    // chamar a atenção do usuário; depois só o selecionado fica em evidência.
    final isHighlighted = isSelected || !widget.hasSelection;

    // "Popa" um pouco no hover/press pra reforçar que o card é clicável.
    final scale = _isPressed ? 0.97 : (_isHovered ? 1.03 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              // Fundo branco se inativo, um verde beeem sutil se
              // selecionado, e um pouco mais forte ainda no hover.
              color: isSelected
                  ? brandGreen.withValues(alpha: _isHovered ? 0.1 : 0.06)
                  : (_isHovered
                        ? brandGreen.withValues(alpha: 0.04)
                        : Colors.white),
              border: Border.all(
                // Borda verde se selecionado, em hover, ou enquanto aguarda
                // a escolha.
                color: isSelected || _isHovered
                    ? brandGreen.withValues(alpha: isSelected ? 1 : 0.7)
                    : (isHighlighted
                          ? brandGreen.withValues(alpha: 0.45)
                          : Colors.grey.shade300),
                width: isSelected ? 2 : 1.4,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (isHighlighted || _isHovered)
                  BoxShadow(
                    color: brandGreen.withValues(
                      alpha: isSelected ? 0.22 : (_isHovered ? 0.2 : 0.14),
                    ),
                    blurRadius: _isHovered ? 18 : 14,
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
                        : brandGreen.withValues(alpha: _isHovered ? 0.2 : 0.12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: isSelected ? Colors.white : brandGreen,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
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
      ),
    );
  }
}
