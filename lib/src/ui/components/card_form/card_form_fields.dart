import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/tsdtech_colors.dart';
import '../../theme/tsdtech_text_styles.dart';
import 'card_brand.dart';

class CardFormField extends StatelessWidget {
  const CardFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    this.enabled = true,
    this.autofocus = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters = const [],
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLength,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final bool enabled;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      maxLength: maxLength,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: TsdtechTextStyles.bodyMedium,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        suffixIcon: suffixIcon,
        labelStyle: TsdtechTextStyles.bodyMedium.copyWith(
          color: TsdtechColors.textSecondary,
        ),
        hintStyle: TsdtechTextStyles.bodyMedium.copyWith(
          color: TsdtechColors.textDisabled,
        ),
        filled: true,
        fillColor: enabled
            ? TsdtechColors.surface
            : TsdtechColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: TsdtechColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: TsdtechColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: TsdtechColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: TsdtechColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: TsdtechColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: TsdtechColors.outlineVariant),
        ),
        errorStyle: TsdtechTextStyles.bodySmall.copyWith(
          color: TsdtechColors.error,
        ),
      ),
    );
  }
}

class CardBrandIcon extends StatelessWidget {
  const CardBrandIcon({super.key, required this.brand});

  final CardBrand brand;

  @override
  Widget build(BuildContext context) {
    if (brand.label.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(right: 12),
        child: Icon(
          Icons.credit_card_outlined,
          color: TsdtechColors.textDisabled,
          size: 22,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Container(
          key: ValueKey(brand),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          decoration: BoxDecoration(
            color: brand.color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            brand.label,
            style: TsdtechTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

class CvvTooltipIcon extends StatelessWidget {
  const CvvTooltipIcon({super.key, required this.isAmex});

  final bool isAmex;

  @override
  Widget build(BuildContext context) {
    final message = isAmex
        ? 'O código de segurança Amex possui 4 dígitos e fica na frente do cartão.'
        : 'O código de segurança (CVV) possui 3 dígitos e fica no verso do cartão.';

    return Tooltip(
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: TsdtechColors.darkSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TsdtechTextStyles.bodySmall.copyWith(
        color: TsdtechColors.darkTextPrimary,
      ),
      child: const Icon(
        Icons.help_outline_rounded,
        size: 20,
        color: TsdtechColors.textSecondary,
      ),
    );
  }
}
