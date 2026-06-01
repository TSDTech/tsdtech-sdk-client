import 'package:flutter/material.dart';

class PixCopyField extends StatelessWidget {
  const PixCopyField({
    super.key,
    required this.copyPasteCode,
    required this.copied,
    required this.expired,
    required this.onCopy,
  });

  final String copyPasteCode;
  final bool copied;
  final bool expired;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF10C484);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pix Copia e Cola',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8), // Mantendo os 8px de padrão
            border: Border.all(
              // Borda verde se copiado, senão cinza clara
              color: copied ? brandGreen : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: SelectableText(
                    copyPasteCode,
                    style: const TextStyle(
                      color: Colors.black54, // Cinza escuro para boa leitura
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              const _VerticalDivider(),
              _CopyButton(
                copied: copied,
                disabled: expired,
                onTap: expired ? null : onCopy,
              ),
            ],
          ),
        ),
        if (copied)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 16,
                  color: brandGreen,
                ),
                SizedBox(width: 6),
                Text(
                  'Código copiado!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: brandGreen,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1, 
      height: 56, 
      color: Colors.grey.shade200, // Divisória sutil
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.copied, required this.disabled, this.onTap});

  final bool copied;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF10C484);

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: disabled
              ? const Icon(
                  key: ValueKey('disabled'),
                  Icons.block_outlined,
                  size: 22,
                  color: Colors.black26,
                )
              : copied
                  ? const Icon(
                      key: ValueKey('check'),
                      Icons.check_rounded,
                      size: 22,
                      color: brandGreen,
                    )
                  : const Icon(
                      key: ValueKey('copy'),
                      Icons.copy_rounded,
                      size: 22,
                      color: brandGreen, // Botão de copiar com a cor da marca
                    ),
        ),
      ),
    );
  }
}