import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voucherize/core/components/ds_text.dart';
import 'package:voucherize/features/checkout/core/stores/checkout_store.dart';

/// Caminho dos ícones de bandeira (SVG). Salve elo.svg, mastercard.svg e visa.svg em assets/icons/card_brands/
const String _cardBrandsPath = 'assets/icons/card_brands';

class PaymentCard extends StatefulWidget {
  final ValueChanged<CardPaymentInput>? onChanged;

  const PaymentCard({super.key, this.onChanged});

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  static const String _installments = '1x';

  static const Color _borderColor = Color.fromRGBO(231, 229, 228, 1);
  static final _inputBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: _borderColor, width: 1),
    borderRadius: BorderRadius.circular(5),
  );
  static const _inputStyle = TextStyle(fontSize: 12, height: 3);
  static const _hintStyle = TextStyle(fontSize: 12, height: 1.0);
  static const _labelStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w700, height: 1.0);
  // Padding 16 horizontal; vertical 15 para total do input = 15+12(line)+15+2(borda) = 44px
  static const _contentPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 15);

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6EEF9)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DsText(
                text: 'Cartão de crédito', variant: DsTextVariant.baseBold),
            const SizedBox(height: 8),
            const DsText(
              text: 'Parcelamento disponível',
              variant: DsTextVariant.small,
              color: Color(0xFF6B7280),
            ),
            const SizedBox(height: 12),

            // 1ª linha: Número do cartão (largura total)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Número do cartão', style: _labelStyle),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CardBrandSvg(asset: '$_cardBrandsPath/elo.svg'),
                        const SizedBox(width: 8),
                        _CardBrandSvg(asset: '$_cardBrandsPath/mastercard.svg'),
                        const SizedBox(width: 8),
                        _CardBrandSvg(asset: '$_cardBrandsPath/visa.svg'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _cardNumberController,
                  style: _inputStyle,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CardNumberInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    hintText: '0000 0000 0000 0000',
                    hintStyle: _hintStyle,
                    contentPadding: _contentPadding,
                    border: _inputBorder,
                    enabledBorder: _inputBorder,
                    focusedBorder: _inputBorder,
                    isDense: true,
                  ),
                  onChanged: (_) => _emitCardChange(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2ª linha: Nome no cartão (largura total)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome no cartão', style: _labelStyle),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _cardHolderController,
                  style: _inputStyle,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Nome Sobrenome',
                    hintStyle: _hintStyle,
                    contentPadding: _contentPadding,
                    border: _inputBorder,
                    enabledBorder: _inputBorder,
                    focusedBorder: _inputBorder,
                    isDense: true,
                  ),
                  onChanged: (_) => _emitCardChange(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 3ª linha: Validade (metade) | CVV (metade)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Validade (MM/AA)', style: _labelStyle),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _expiryController,
                        style: _inputStyle,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          ExpiryDateTextInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          hintText: 'MM/AA',
                          hintStyle: _hintStyle,
                          contentPadding: _contentPadding,
                          border: _inputBorder,
                          enabledBorder: _inputBorder,
                          focusedBorder: _inputBorder,
                          isDense: true,
                        ),
                        onChanged: (_) => _emitCardChange(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CVV', style: _labelStyle),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _cvvController,
                        style: _inputStyle,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4)
                        ],
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '123',
                          hintStyle: _hintStyle,
                          contentPadding: _contentPadding,
                          border: _inputBorder,
                          enabledBorder: _inputBorder,
                          focusedBorder: _inputBorder,
                          isDense: true,
                        ),
                        onChanged: (_) => _emitCardChange(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Placeholder note
            const DsText(
                text:
                    'Os campos acima são apenas para preenchimento (sem ação).',
                variant: DsTextVariant.small,
                color: Color(0xFF6B7280)),
          ],
        ),
      ),
    );
  }

  void _emitCardChange() {
    widget.onChanged?.call(
      CardPaymentInput(
        cardNumber: _cardNumberController.text,
        cardHolderName: _cardHolderController.text,
        expiryDate: _expiryController.text,
        securityCode: _cvvController.text,
        installments: _installments,
      ),
    );
  }
}

/// Ícone de bandeira de cartão (Elo, Mastercard, Visa). Trocar por Image.asset quando tiver logos.
/// Exibe ícone de bandeira de cartão a partir de SVG.
/// Coloque os arquivos em assets/icons/card_brands/: elo.svg, mastercard.svg, visa.svg
class _CardBrandSvg extends StatelessWidget {
  final String asset;
  static const double _size = 32;

  const _CardBrandSvg({required this.asset});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: _size,
      height: _size,
      fit: BoxFit.contain,
      placeholderBuilder: (_) => SizedBox(width: _size, height: _size),
    );
  }
}

/// Formata o número do cartão como 1111 1111 1111 1111 e limita a 16 dígitos.
class CardNumberInputFormatter extends TextInputFormatter {
  static const int _maxDigits = 16;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final limited =
        digits.length > _maxDigits ? digits.substring(0, _maxDigits) : digits;
    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(limited[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Simple formatter that converts a sequence of digits into MM/YY with a slash.
class ExpiryDateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Keep only digits
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted = digits;
    if (digits.length >= 3) {
      formatted = digits.substring(0, 2) +
          '/' +
          digits.substring(2, digits.length > 4 ? 4 : digits.length);
    } else if (digits.length >= 1 && digits.length <= 2) {
      formatted = digits;
    }

    // Ensure max length MM/YY => 5 with slash
    if (formatted.length > 5) formatted = formatted.substring(0, 5);

    // Place cursor at the end
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
