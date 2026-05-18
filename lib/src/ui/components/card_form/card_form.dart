import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../stores/card_form_store.dart';
import '../../theme/tsdtech_colors.dart';
import '../../theme/tsdtech_text_styles.dart';
import 'card_brand.dart';
import 'card_form_controller.dart';
import 'card_form_data.dart';
import 'card_form_fields.dart';
import 'card_form_formatters.dart';

class CardForm extends StatelessWidget {
  const CardForm({
    super.key,
    this.controller,
    required this.store,
    this.onChanged,
    this.onSubmit,
    this.submitLabel = 'Pagar',
    this.showSubmitButton = true,
    this.enabled = true,
    this.autofocus = false,
  });

  final CardFormController? controller;
  final CardFormStore store;
  final void Function(CardFormData data)? onChanged;
  final void Function(CardFormData data)? onSubmit;
  final String submitLabel;
  final bool showSubmitButton;
  final bool enabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final effectiveStore = store;
    controller?.bindStore(effectiveStore);

    void notifyChanged() => onChanged?.call(effectiveStore.data);

    void handleSubmit() {
      if (effectiveStore.validateForm()) {
        onSubmit?.call(effectiveStore.data);
      }
    }

    String? validateCardNumber(String? value) {
      if (value == null || value.isEmpty) return 'Número do cartão obrigatório';
      final digits = value.replaceAll(' ', '');
      final required = effectiveStore.brand == CardBrand.amex ? 15 : 16;
      if (digits.length < required) return 'Número do cartão incompleto';
      if (!_luhnCheck(digits)) return 'Número do cartão inválido';
      return null;
    }

    String? validateName(String? value) {
      if (value == null || value.trim().isEmpty) return 'Nome do titular obrigatório';
      if (value.trim().split(RegExp(r'\s+')).length < 2) return 'Informe o nome completo';
      return null;
    }

    String? validateExpiry(String? value) {
      if (value == null || value.isEmpty) return 'Validade obrigatória';
      if (value.length < 5) return 'Validade incompleta (MM/AA)';
      final parts = value.split('/');
      final month = int.tryParse(parts[0]);
      final year = int.tryParse(parts[1]);
      if (month == null || year == null) return 'Validade inválida';
      if (month < 1 || month > 12) return 'Mês inválido';
      final now = DateTime.now();
      final expiry = DateTime(2000 + year, month + 1);
      if (expiry.isBefore(DateTime(now.year, now.month))) return 'Cartão expirado';
      return null;
    }

    String? validateCvv(String? value) {
      if (value == null || value.isEmpty) return 'CVV obrigatório';
      final isAmex = effectiveStore.brand == CardBrand.amex;
      final required = isAmex ? 4 : 3;
      if (value.length < required) {
        return isAmex ? 'CVV deve ter 4 dígitos' : 'CVV deve ter 3 dígitos';
      }
      return null;
    }

    String? validateTaxId(String? value) {
      if (value == null || value.isEmpty) return 'CPF/CNPJ obrigatório';
      final digits = value.replaceAll(RegExp(r'\D'), '');
      if (digits.length == 11) return _validCpf(digits) ? null : 'CPF inválido';
      if (digits.length == 14) return _validCnpj(digits) ? null : 'CNPJ inválido';
      return 'CPF/CNPJ incompleto';
    }

    return Observer(
      builder: (_) {
        final isAmex = effectiveStore.isAmex;

        return Form(
          key: effectiveStore.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardFormField(
                fieldKey: ValueKey('card-number-${effectiveStore.formVersion}'),
                initialValue: effectiveStore.cardNumber,
                label: 'Número do cartão',
                hint: '0000 0000 0000 0000',
                enabled: enabled,
                autofocus: autofocus,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CardNumberFormatter(
                    onBrandChanged: (brand) {
                      if (brand != effectiveStore.brand) {
                        effectiveStore.setBrand(brand);
                        if (effectiveStore.cvv.isNotEmpty) {
                          effectiveStore.clearCvv();
                        }
                        notifyChanged();
                      }
                    },
                  ),
                ],
                suffixIcon: CardBrandIcon(brand: effectiveStore.brand),
                validator: validateCardNumber,
                onChanged: (value) {
                  effectiveStore.updateCardNumber(value);
                  notifyChanged();
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 16),
              CardFormField(
                fieldKey: ValueKey('card-name-${effectiveStore.formVersion}'),
                initialValue: effectiveStore.cardholderName,
                label: 'Nome do titular',
                hint: 'Como impresso no cartão',
                enabled: enabled,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ú\s]')),
                ],
                validator: validateName,
                onChanged: (value) {
                  effectiveStore.updateCardholderName(value);
                  notifyChanged();
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CardFormField(
                      fieldKey: ValueKey('card-expiry-${effectiveStore.formVersion}'),
                      initialValue: effectiveStore.expiryDate,
                      label: 'Validade',
                      hint: 'MM/AA',
                      enabled: enabled,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ExpiryFormatter()],
                      validator: validateExpiry,
                      onChanged: (value) {
                        effectiveStore.updateExpiryDate(value);
                        notifyChanged();
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CardFormField(
                      fieldKey: ValueKey(
                        'card-cvv-${effectiveStore.formVersion}-${effectiveStore.cvvFieldVersion}',
                      ),
                      initialValue: effectiveStore.cvv,
                      label: 'CVV',
                      hint: isAmex ? '4 dígitos' : '3 dígitos',
                      enabled: enabled,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: isAmex ? 4 : 3,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(isAmex ? 4 : 3),
                      ],
                      suffixIcon: CvvTooltipIcon(isAmex: isAmex),
                      validator: validateCvv,
                      onChanged: (value) {
                        effectiveStore.updateCvv(value);
                        notifyChanged();
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CardFormField(
                fieldKey: ValueKey('card-taxid-${effectiveStore.formVersion}'),
                initialValue: effectiveStore.taxId,
                label: 'CPF/CNPJ do titular',
                hint: '000.000.000-00',
                enabled: enabled,
                keyboardType: TextInputType.number,
                inputFormatters: [TaxIdFormatter()],
                validator: validateTaxId,
                onChanged: (value) {
                  effectiveStore.updateTaxId(value);
                  notifyChanged();
                },
                textInputAction: showSubmitButton
                    ? TextInputAction.done
                    : TextInputAction.next,
                onFieldSubmitted:
                    showSubmitButton ? (_) => handleSubmit() : null,
              ),
              if (showSubmitButton) ...[
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: enabled ? handleSubmit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: TsdtechColors.primary,
                    foregroundColor: TsdtechColors.textOnPrimary,
                    minimumSize: const Size.fromHeight(52),
                    textStyle: TsdtechTextStyles.titleMedium.copyWith(
                      color: TsdtechColors.textOnPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(submitLabel),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

bool _luhnCheck(String digits) {
  if (digits.isEmpty) return false;
  int sum = 0;
  bool alternate = false;
  for (int i = digits.length - 1; i >= 0; i--) {
    int n = int.parse(digits[i]);
    if (alternate) {
      n *= 2;
      if (n > 9) n -= 9;
    }
    sum += n;
    alternate = !alternate;
  }
  return sum % 10 == 0;
}

bool _validCpf(String digits) {
  if (digits.length != 11) return false;
  if (RegExp(r'^(\d)\1{10}$').hasMatch(digits)) return false;

  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(digits[i]) * (10 - i);
  }
  int r = (sum * 10) % 11;
  if (r == 10 || r == 11) r = 0;
  if (r != int.parse(digits[9])) return false;

  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += int.parse(digits[i]) * (11 - i);
  }
  r = (sum * 10) % 11;
  if (r == 10 || r == 11) r = 0;
  return r == int.parse(digits[10]);
}

bool _validCnpj(String digits) {
  if (digits.length != 14) return false;
  if (RegExp(r'^(\d)\1{13}$').hasMatch(digits)) return false;

  const weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  const weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  int sum = 0;
  for (int i = 0; i < 12; i++) {
    sum += int.parse(digits[i]) * weights1[i];
  }
  int r = sum % 11;
  final d1 = r < 2 ? 0 : 11 - r;
  if (d1 != int.parse(digits[12])) return false;

  sum = 0;
  for (int i = 0; i < 13; i++) {
    sum += int.parse(digits[i]) * weights2[i];
  }
  r = sum % 11;
  final d2 = r < 2 ? 0 : 11 - r;
  return d2 == int.parse(digits[13]);
}
