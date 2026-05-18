import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../components/card_form/card_form.dart';
import '../../components/card_form/card_form_controller.dart';
import '../../components/card_form/card_form_data.dart';
import '../../stores/payment_store.dart';
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
    this.store,
    this.enabled = true,
    this.isLoading = false,
    this.submitLabel = 'Pagar',
    this.cardAutofocus = false,
    this.onMethodChanged,
    required this.onSubmit,
  });

  final PaymentFormMethod initialMethod;
  final PaymentStore? store;
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
  final CardFormController _cardController = CardFormController();
  late PaymentStore _store;

  @override
  void initState() {
    super.initState();
    _configureStore();
  }

  @override
  void didUpdateWidget(covariant PaymentForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.store != widget.store) {
      _configureStore();
    }

    _store.setEnabled(widget.enabled);
    _store.setLoading(widget.isLoading);
  }

  void _configureStore() {
    _store = widget.store ?? PaymentStore(initialMethod: widget.initialMethod);
    _store.setEnabled(widget.enabled);
    _store.setLoading(widget.isLoading);
  }

  void _selectMethod(PaymentFormMethod method) {
    final previousMethod = _store.selectedMethod;
    _store.selectMethod(method);
    if (_store.selectedMethod != previousMethod) {
      widget.onMethodChanged?.call(_store.selectedMethod);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_store.canInteract) return;

    CardFormData? cardData;
    if (_store.isCardSelected) {
      if (!_cardController.validate()) return;
      cardData = _cardController.data;
      if (cardData == null) return;
      _store.setCardData(cardData);
    }

    _store.markSubmitted();
    widget.onSubmit(_store.currentData);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final canInteract = _store.canInteract;
        final selectedMethod = _store.selectedMethod;

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
                      selected: method == selectedMethod,
                      enabled: canInteract,
                      onSelected: () => _selectMethod(method),
                    ),
                  )
                  .toList(),
            ),
            if (_store.isCardSelected) ...[
              const SizedBox(height: 20),
              CardForm(
                controller: _cardController,
                store: _store.cardFormStore,
                enabled: canInteract,
                autofocus: widget.cardAutofocus,
                showSubmitButton: false,
              ),
            ],
            const SizedBox(height: 20),
            PaymentSubmitButton(
              method: selectedMethod,
              label: widget.submitLabel,
              loading: _store.isLoading,
              enabled: canInteract,
              onPressed: _handleSubmit,
            ),
          ],
        );
      },
    );
  }
}
