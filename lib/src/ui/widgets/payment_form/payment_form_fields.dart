import 'package:flutter/material.dart';

import '../../theme/tsdtech_colors.dart';
import '../../theme/tsdtech_text_styles.dart';
import 'payment_form_method.dart';

class PaymentMethodChip extends StatelessWidget {
  const PaymentMethodChip({
    super.key,
    required this.method,
    required this.selected,
    required this.enabled,
    required this.onSelected,
  });

  final PaymentFormMethod method;
  final bool selected;
  final bool enabled;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(method.label),
      selected: selected,
      onSelected: enabled ? (_) => onSelected() : null,
      labelStyle: TsdtechTextStyles.bodyMedium.copyWith(
        color: selected
            ? TsdtechColors.textOnPrimary
            : TsdtechColors.textSecondary,
      ),
      backgroundColor: TsdtechColors.surface,
      disabledColor: TsdtechColors.surfaceVariant,
      selectedColor: TsdtechColors.primary,
      side: BorderSide(
        color: selected ? TsdtechColors.primary : TsdtechColors.outline,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      avatar: Icon(
        method.chipIcon,
        size: 16,
        color: selected
            ? TsdtechColors.textOnPrimary
            : TsdtechColors.textSecondary,
      ),
    );
  }
}

class PaymentSubmitButton extends StatelessWidget {
  const PaymentSubmitButton({
    super.key,
    required this.method,
    required this.label,
    required this.loading,
    required this.enabled,
    required this.onPressed,
  });

  final PaymentFormMethod method;
  final String label;
  final bool loading;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: TsdtechColors.primary,
        foregroundColor: TsdtechColors.textOnPrimary,
        minimumSize: const Size.fromHeight(52),
        textStyle: TsdtechTextStyles.titleMedium.copyWith(
          color: TsdtechColors.textOnPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: loading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: TsdtechColors.textOnPrimary,
              ),
            )
          : Icon(method.submitIcon),
      label: Text(label),
    );
  }
}
