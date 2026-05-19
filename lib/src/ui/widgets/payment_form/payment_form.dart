import 'package:flutter/material.dart';

import '../../components/card_form/card_form.dart';
import '../../components/card_form/card_form_controller.dart';
import '../../components/card_form/card_form_data.dart';
import '../../theme/tsdtech_colors.dart';
import '../../theme/tsdtech_text_styles.dart';
import 'payment_form_data.dart';
import 'payment_form_fields.dart';
import 'payment_form_method.dart';

export 'payment_form_data.dart';
export 'payment_form_method.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({
    super.key,
    this.initialMethod = PaymentFormMethod.pix,
    this.enabled = true,
    this.isLoading = false,
    this.submitLabel = 'Pagar',
    this.cardAutofocus = false,
    this.onMethodChanged,
    required this.onSubmit,
  });

  final PaymentFormMethod initialMethod;
  final bool enabled;
  final bool isLoading;
  final String submitLabel;
  final bool cardAutofocus;
  final ValueChanged<PaymentFormMethod>? onMethodChanged;
  final ValueChanged<PaymentFormData> onSubmit;

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  late PaymentFormMethod _selectedMethod;
  final CardFormController _cardController = CardFormController();

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.initialMethod;
  }

  void _selectMethod(PaymentFormMethod method) {
    if (!widget.enabled || widget.isLoading || method == _selectedMethod) {
      return;
    }

    setState(() => _selectedMethod = method);
    widget.onMethodChanged?.call(method);
  }

  Future<void> _handleSubmit() async {
    if (!widget.enabled || widget.isLoading) return;

    CardFormData? cardData;
    if (_selectedMethod == PaymentFormMethod.card) {
      if (!_cardController.validate()) return;
      cardData = _cardController.data;
      if (cardData == null) return;
    }

    widget.onSubmit(
      PaymentFormData(method: _selectedMethod, cardData: cardData),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canInteract = widget.enabled && !widget.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Forma de pagamento',
          style: TsdtechTextStyles.titleMedium.copyWith(
            color: TsdtechColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: PaymentFormMethod.values
              .map(
                (method) => PaymentMethodChip(
                  method: method,
                  selected: method == _selectedMethod,
                  enabled: canInteract,
                  onSelected: () => _selectMethod(method),
                ),
              )
              .toList(),
        ),
        if (_selectedMethod == PaymentFormMethod.card) ...[
          const SizedBox(height: 20),
          CardForm(
            controller: _cardController,
            enabled: canInteract,
            autofocus: widget.cardAutofocus,
            showSubmitButton: false,
          ),
        ],
        const SizedBox(height: 20),
        PaymentSubmitButton(
          method: _selectedMethod,
          label: widget.submitLabel,
          loading: widget.isLoading,
          enabled: canInteract,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
