import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../stores/card_form_store.dart';
import '../../theme/tsdtech_colors.dart';
import '../../theme/tsdtech_text_styles.dart';
import 'card_brand.dart';
import 'card_form_controller.dart';
import 'card_form_data.dart';
import 'card_form_fields.dart';
import 'card_form_formatters.dart';

class CardForm extends StatefulWidget {
  const CardForm({
    super.key,
    this.controller,
    this.store,
    this.onChanged,
    this.onSubmit,
    this.submitLabel = 'Pagar',
    this.showSubmitButton = true,
    this.enabled = true,
    this.autofocus = false,
  });

  final CardFormController? controller;
  final CardFormStore? store;
  final void Function(CardFormData data)? onChanged;
  final void Function(CardFormData data)? onSubmit;
  final String submitLabel;
  final bool showSubmitButton;
  final bool enabled;
  final bool autofocus;

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> implements CardFormScope {
  final _formKey = GlobalKey<FormState>();
  final List<ReactionDisposer> _storeReactions = <ReactionDisposer>[];

  late final TextEditingController _cardNumberCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _expiryCtrl;
  late final TextEditingController _cvvCtrl;
  late final TextEditingController _taxIdCtrl;

  final _cardNumberFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _cvvFocus = FocusNode();
  final _taxIdFocus = FocusNode();

  late CardFormStore _store;

  @override
  void initState() {
    super.initState();
    _cardNumberCtrl = TextEditingController();
    _nameCtrl = TextEditingController();
    _expiryCtrl = TextEditingController();
    _cvvCtrl = TextEditingController();
    _taxIdCtrl = TextEditingController();
    _bindStore(widget.store);
    widget.controller?.attach(this);
  }

  @override
  void didUpdateWidget(CardForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.store != widget.store) {
      _bindStore(widget.store);
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach();
      widget.controller?.attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?.detach();
    _disposeStoreReactions();
    _cardNumberCtrl.dispose();
    _nameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _taxIdCtrl.dispose();
    _cardNumberFocus.dispose();
    _nameFocus.dispose();
    _expiryFocus.dispose();
    _cvvFocus.dispose();
    _taxIdFocus.dispose();
    super.dispose();
  }

  void _bindStore(CardFormStore? store) {
    _disposeStoreReactions();
    _store = store ?? CardFormStore();
    _syncControllersFromStore();
    _storeReactions.addAll(<ReactionDisposer>[
      reaction<String>((_) => _store.cardNumber, (value) {
        _syncControllerValue(_cardNumberCtrl, value);
      }),
      reaction<String>((_) => _store.cardholderName, (value) {
        _syncControllerValue(_nameCtrl, value);
      }),
      reaction<String>((_) => _store.expiryDate, (value) {
        _syncControllerValue(_expiryCtrl, value);
      }),
      reaction<String>((_) => _store.cvv, (value) {
        _syncControllerValue(_cvvCtrl, value);
      }),
      reaction<String>((_) => _store.taxId, (value) {
        _syncControllerValue(_taxIdCtrl, value);
      }),
    ]);
  }

  void _disposeStoreReactions() {
    for (final disposer in _storeReactions) {
      disposer();
    }
    _storeReactions.clear();
  }

  void _syncControllersFromStore() {
    _syncControllerValue(_cardNumberCtrl, _store.cardNumber);
    _syncControllerValue(_nameCtrl, _store.cardholderName);
    _syncControllerValue(_expiryCtrl, _store.expiryDate);
    _syncControllerValue(_cvvCtrl, _store.cvv);
    _syncControllerValue(_taxIdCtrl, _store.taxId);
  }

  void _syncControllerValue(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }

    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  @override
  bool validateForm() => _formKey.currentState?.validate() ?? false;

  @override
  CardFormData buildData() => _store.data;

  @override
  void resetForm() {
    _formKey.currentState?.reset();
    _store.reset();
  }

  void _notifyChanged() => widget.onChanged?.call(_store.data);

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(_store.data);
    }
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) return 'Número do cartão obrigatório';
    final digits = value.replaceAll(' ', '');
    final required = _store.brand == CardBrand.amex ? 15 : 16;
    if (digits.length < required) return 'Número do cartão incompleto';
    if (!_luhnCheck(digits)) return 'Número do cartão inválido';
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nome do titular obrigatório';
    if (value.trim().split(RegExp(r'\s+')).length < 2) return 'Informe o nome completo';
    return null;
  }

  String? _validateExpiry(String? value) {
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

  String? _validateCvv(String? value) {
    if (value == null || value.isEmpty) return 'CVV obrigatório';
    final isAmex = _store.brand == CardBrand.amex;
    final required = isAmex ? 4 : 3;
    if (value.length < required) {
      return isAmex ? 'CVV deve ter 4 dígitos' : 'CVV deve ter 3 dígitos';
    }
    return null;
  }

  String? _validateTaxId(String? value) {
    if (value == null || value.isEmpty) return 'CPF/CNPJ obrigatório';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11) return _validCpf(digits) ? null : 'CPF inválido';
    if (digits.length == 14) return _validCnpj(digits) ? null : 'CNPJ inválido';
    return 'CPF/CNPJ incompleto';
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isAmex = _store.isAmex;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardFormField(
                controller: _cardNumberCtrl,
                focusNode: _cardNumberFocus,
                label: 'Número do cartão',
                hint: '0000 0000 0000 0000',
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CardNumberFormatter(
                    onBrandChanged: (brand) {
                      if (brand != _store.brand) {
                        _store.setBrand(brand);
                        if (_cvvCtrl.text.isNotEmpty) {
                          _store.updateCvv('');
                        }
                        _notifyChanged();
                      }
                    },
                  ),
                ],
                suffixIcon: CardBrandIcon(brand: _store.brand),
                validator: _validateCardNumber,
                onChanged: (value) {
                  _store.updateCardNumber(value);
                  _notifyChanged();
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _nameFocus.requestFocus(),
              ),
              const SizedBox(height: 16),
              CardFormField(
                controller: _nameCtrl,
                focusNode: _nameFocus,
                label: 'Nome do titular',
                hint: 'Como impresso no cartão',
                enabled: widget.enabled,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ú\s]')),
                ],
                validator: _validateName,
                onChanged: (value) {
                  _store.updateCardholderName(value);
                  _notifyChanged();
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _expiryFocus.requestFocus(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CardFormField(
                      controller: _expiryCtrl,
                      focusNode: _expiryFocus,
                      label: 'Validade',
                      hint: 'MM/AA',
                      enabled: widget.enabled,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ExpiryFormatter()],
                      validator: _validateExpiry,
                      onChanged: (value) {
                        _store.updateExpiryDate(value);
                        _notifyChanged();
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => _cvvFocus.requestFocus(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CardFormField(
                      controller: _cvvCtrl,
                      focusNode: _cvvFocus,
                      label: 'CVV',
                      hint: isAmex ? '4 dígitos' : '3 dígitos',
                      enabled: widget.enabled,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: isAmex ? 4 : 3,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(isAmex ? 4 : 3),
                      ],
                      suffixIcon: CvvTooltipIcon(isAmex: isAmex),
                      validator: _validateCvv,
                      onChanged: (value) {
                        _store.updateCvv(value);
                        _notifyChanged();
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => _taxIdFocus.requestFocus(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CardFormField(
                controller: _taxIdCtrl,
                focusNode: _taxIdFocus,
                label: 'CPF/CNPJ do titular',
                hint: '000.000.000-00',
                enabled: widget.enabled,
                keyboardType: TextInputType.number,
                inputFormatters: [TaxIdFormatter()],
                validator: _validateTaxId,
                onChanged: (value) {
                  _store.updateTaxId(value);
                  _notifyChanged();
                },
                textInputAction: widget.showSubmitButton
                    ? TextInputAction.done
                    : TextInputAction.next,
                onFieldSubmitted:
                    widget.showSubmitButton ? (_) => _handleSubmit() : null,
              ),
              if (widget.showSubmitButton) ...[
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: widget.enabled ? _handleSubmit : null,
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
                  child: Text(widget.submitLabel),
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
