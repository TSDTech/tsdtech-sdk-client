import 'package:flutter/material.dart';

class CardPaymentView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cardHolderController;
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController securityCodeController;

  const CardPaymentView({
    super.key,
    required this.formKey,
    required this.cardHolderController,
    required this.cardNumberController,
    required this.expiryController,
    required this.securityCodeController,
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
            _buildTextField(cardHolderController, 'Nome no cartão', TextInputType.name),
            const SizedBox(height: 12),
            _buildTextField(cardNumberController, 'Número do cartão', TextInputType.number, maxLength: 19),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(expiryController, 'MM/AA', TextInputType.datetime, maxLength: 5),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(securityCodeController, 'CVV', TextInputType.number, maxLength: 4, obscureText: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType, {
    int? maxLength,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
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