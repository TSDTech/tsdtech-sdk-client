import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../components/card_form/card_form.dart';
import '../../components/card_form/card_form_data.dart';
import '../../stores/payment_store.dart';
import '../../theme/tsdtech_colors.dart';
import '../../theme/tsdtech_text_styles.dart';
import 'payment_form_data.dart';
import 'payment_form_fields.dart';
import 'payment_form_method.dart';

export 'payment_form_data.dart';
export 'payment_form_method.dart';

class PaymentForm extends StatelessWidget {
  const PaymentForm({
    super.key,
    required this.store,
    this.enabled = true,
    this.isLoading = false,
    this.submitLabel = 'Pagar',
    this.cardAutofocus = false,
    this.onMethodChanged,
    required this.onSubmit,
  });

  final PaymentStore store;
  final bool enabled;
  final bool isLoading;
  final String submitLabel;
  final bool cardAutofocus;
  final ValueChanged<PaymentFormMethod>? onMethodChanged;
  final ValueChanged<PaymentFormData> onSubmit;

  @override
  Widget build(BuildContext context) {
    final effectiveStore = store;
    effectiveStore.setEnabled(enabled);
    effectiveStore.setLoading(isLoading);

    void selectMethod(PaymentFormMethod method) {
      final previousMethod = effectiveStore.selectedMethod;
      effectiveStore.selectMethod(method);
      if (effectiveStore.selectedMethod != previousMethod) {
        onMethodChanged?.call(effectiveStore.selectedMethod);
      }
    }

    Future<void> handleSubmit() async {
      if (!effectiveStore.canInteract) return;

      CardFormData? cardData;
      if (effectiveStore.isCardSelected) {
        if (!effectiveStore.cardFormStore.validateForm()) return;
        cardData = effectiveStore.cardFormStore.data;
        effectiveStore.setCardData(cardData);
      }

      effectiveStore.markSubmitted();
      onSubmit(effectiveStore.currentData);
    }

    return Observer(
      builder: (_) {
        final canInteract = effectiveStore.canInteract;
        final selectedMethod = effectiveStore.selectedMethod;

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
                      onSelected: () => selectMethod(method),
                    ),
                  )
                  .toList(),
            ),
            if (effectiveStore.isCardSelected) ...[
              const SizedBox(height: 20),
              CardForm(
                store: effectiveStore.cardFormStore,
                enabled: canInteract,
                autofocus: cardAutofocus,
                showSubmitButton: false,
              ),
            ],
            const SizedBox(height: 20),
            PaymentSubmitButton(
              method: selectedMethod,
              label: submitLabel,
              loading: effectiveStore.isLoading,
              enabled: canInteract,
              onPressed: handleSubmit,
            ),
          ],
        );
      },
    );
  }
}
