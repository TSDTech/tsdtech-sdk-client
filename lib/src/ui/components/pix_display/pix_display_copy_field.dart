import 'package:flutter/material.dart';

import '../../theme/tsdtech_colors.dart';
import '../../theme/tsdtech_text_styles.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pix Copia e Cola', style: TsdtechTextStyles.titleSmall),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: TsdtechColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: copied ? TsdtechColors.success : TsdtechColors.outline,
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
                    style: TsdtechTextStyles.bodySmall.copyWith(
                      color: TsdtechColors.textSecondary,
                      fontFamily: 'monospace',
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
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 14,
                  color: TsdtechColors.success,
                ),
                const SizedBox(width: 4),
                Text(
                  'Código copiado!',
                  style: TsdtechTextStyles.bodySmall.copyWith(
                    color: TsdtechColors.success,
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
    return Container(width: 1, height: 56, color: TsdtechColors.outline);
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.copied, required this.disabled, this.onTap});

  final bool copied;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: disabled
              ? const Icon(
                  key: ValueKey('disabled'),
                  Icons.block_outlined,
                  size: 20,
                  color: TsdtechColors.textDisabled,
                )
              : copied
              ? const Icon(
                  key: ValueKey('check'),
                  Icons.check_rounded,
                  size: 20,
                  color: TsdtechColors.success,
                )
              : const Icon(
                  key: ValueKey('copy'),
                  Icons.copy_rounded,
                  size: 20,
                  color: TsdtechColors.primary,
                ),
        ),
      ),
    );
  }
}
