import 'package:flutter/material.dart';

class CardPaymentView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final int formVersion;
  final String cardHolderName;
  final String cardNumber;
  final String expiryDate;
  final String securityCode;
  final ValueChanged<String> onCardHolderChanged;
  final ValueChanged<String> onCardNumberChanged;
  final ValueChanged<String> onExpiryChanged;
  final ValueChanged<String> onSecurityCodeChanged;

  const CardPaymentView({
    super.key,
    required this.formKey,
    required this.formVersion,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.securityCode,
    required this.onCardHolderChanged,
    required this.onCardNumberChanged,
    required this.onExpiryChanged,
    required this.onSecurityCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildTextField(
              fieldKey: ValueKey('checkout-holder-$formVersion'),
              initialValue: cardHolderName,
              label: 'Nome no cartão',
              keyboardType: TextInputType.name,
              onChanged: onCardHolderChanged,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              fieldKey: ValueKey('checkout-number-$formVersion'),
              initialValue: cardNumber,
              label: 'Número do cartão',
              keyboardType: TextInputType.number,
              maxLength: 19,
              onChanged: onCardNumberChanged,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    fieldKey: ValueKey('checkout-expiry-$formVersion'),
                    initialValue: expiryDate,
                    label: 'MM/AA',
                    keyboardType: TextInputType.datetime,
                    maxLength: 5,
                    onChanged: onExpiryChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    fieldKey: ValueKey('checkout-cvv-$formVersion'),
                    initialValue: securityCode,
                    label: 'CVV',
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                    onChanged: onSecurityCodeChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required Key fieldKey,
    required String initialValue,
    required String label,
    required TextInputType keyboardType,
    required ValueChanged<String> onChanged,
    int? maxLength,
    bool obscureText = false,
  }) {
    return TextFormField(
      key: fieldKey,
      initialValue: initialValue,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        counterText: '', // Oculta o contador de caracteres
      ),
    );
  }
}