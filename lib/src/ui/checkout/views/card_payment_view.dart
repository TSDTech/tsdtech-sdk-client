import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsdtech_client_sdk/src/ui/components/card_form/card_brand.dart';
import 'package:tsdtech_client_sdk/src/ui/components/card_form/card_form_fields.dart';
import 'package:tsdtech_client_sdk/src/ui/components/card_form/card_form_formatters.dart';

class CardPaymentView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final int formVersion;
  final String cardHolderName;
  final String cardNumber;
  final String expiryDate;
  final String securityCode;
  final String taxId; // NOVO: Propriedade do CPF/CNPJ
  final ValueChanged<String> onCardHolderChanged;
  final ValueChanged<String> onCardNumberChanged;
  final ValueChanged<String> onExpiryChanged;
  final ValueChanged<String> onSecurityCodeChanged;
  final ValueChanged<String> onTaxIdChanged; // NOVO: Callback do CPF/CNPJ

  const CardPaymentView({
    super.key,
    required this.formKey,
    required this.formVersion,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.securityCode,
    required this.taxId, // NOVO
    required this.onCardHolderChanged,
    required this.onCardNumberChanged,
    required this.onExpiryChanged,
    required this.onSecurityCodeChanged,
    required this.onTaxIdChanged, // NOVO
  });

  // Lógica local para saber se é Amex e mudar o limite do CVV / Tooltip
  bool get _isAmex {
    final clean = cardNumber.replaceAll(RegExp(r'\D'), '');
    return clean.startsWith('34') || clean.startsWith('37');
  }

  // Lógica local para descobrir a bandeira pro ícone (CardBrandIcon)
  // Obs: Se o seu enum não tiver "unknown", troque pelo valor padrão correto.
  dynamic get _currentBrand {
    final clean = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (clean.isEmpty) return CardBrand.unknown;
    if (clean.startsWith('34') || clean.startsWith('37')) return CardBrand.amex;
    if (clean.startsWith('4')) return CardBrand.visa;
    if (RegExp(r'^5[1-5]').hasMatch(clean)) return CardBrand.mastercard;
    return CardBrand.unknown;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Número do Cartão
          CardFormField(
            fieldKey: ValueKey('checkout-number-$formVersion'),
            initialValue: cardNumber,
            label: 'Número do cartão',
            hint: '0000 0000 0000 0000',
            keyboardType: TextInputType.number,
            inputFormatters: [
              CardNumberFormatter(), // O seu formatador original!
            ],
            suffixIcon: CardBrandIcon(
              brand: _currentBrand,
            ), // O seu ícone dinâmico!
            onChanged: onCardNumberChanged,
            textInputAction: TextInputAction.next,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Campo obrigatório'
                : null,
          ),
          const SizedBox(height: 16),

          // 2. Nome do Titular
          CardFormField(
            fieldKey: ValueKey('checkout-name-$formVersion'),
            initialValue: cardHolderName,
            label: 'Nome do titular',
            hint: 'Como impresso no cartão',
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ú\s]')),
            ],
            onChanged: onCardHolderChanged,
            textInputAction: TextInputAction.next,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Campo obrigatório'
                : null,
          ),
          const SizedBox(height: 16),

          // 3. Validade e CVV lado a lado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CardFormField(
                  fieldKey: ValueKey('checkout-expiry-$formVersion'),
                  initialValue: expiryDate,
                  label: 'Validade',
                  hint: 'MM/AA',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    ExpiryFormatter(), // O seu formatador de validade original!
                  ],
                  onChanged: onExpiryChanged,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              // CVV tem no máximo 4 dígitos: largura fixa em vez de esticar
              SizedBox(
                width: 150,
                child: CardFormField(
                  fieldKey: ValueKey('checkout-cvv-$formVersion'),
                  initialValue: securityCode,
                  label: 'CVV',
                  hint: _isAmex ? '4 dígitos' : '3 dígitos',
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: _isAmex ? 4 : 3,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_isAmex ? 4 : 3),
                  ],
                  suffixIcon: CvvTooltipIcon(
                    isAmex: _isAmex,
                  ), // O seu tooltip de CVV!
                  onChanged: onSecurityCodeChanged,
                  textInputAction: TextInputAction.next, // Mudou para next
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. CPF/CNPJ (NOVO)
          CardFormField(
            fieldKey: ValueKey('checkout-taxid-$formVersion'),
            initialValue: taxId,
            label: 'CPF/CNPJ do titular',
            hint: '000.000.000-00',
            keyboardType: TextInputType.number,
            inputFormatters: [
              TaxIdFormatter(), // O seu formatador de documento original!
            ],
            onChanged: onTaxIdChanged,
            textInputAction: TextInputAction.done, // Agora esse é o último!
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Campo obrigatório'
                : null,
          ),
        ],
      ),
    );
  }
}
