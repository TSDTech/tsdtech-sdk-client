import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/core/components/ds_button.dart';
import 'package:tsdtech_client_sdk/features/cart/core/stores/cart_store.dart';
import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String code;
  final String description;
  final String price;
  final List<String> tags;
  final VoidCallback? onAdd;
  final Service? service;

  const ServiceCard(
      {required this.title,
      required this.code,
      required this.description,
      required this.price,
      required this.tags,
      this.onAdd,
      this.service,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E9EE)),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(16, 24, 40, 0.03),
              blurRadius: 10,
              offset: Offset(0, 4)),
          BoxShadow(
              color: Color.fromRGBO(16, 24, 40, 0.02),
              blurRadius: 2,
              offset: Offset(0, 1)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DsText(text: title, variant: DsTextVariant.baseBold),
            const SizedBox(height: 8),
            DsText(text: 'Código: $code', variant: DsTextVariant.small),
            const SizedBox(height: 8),
            DsText(
                text: description,
                variant: DsTextVariant.small,
                maxLines: 4,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
            // Tags row
            if (tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((t) => _buildTag(context, t)).toList(),
              ),
            const SizedBox(height: 12),
            const Spacer(),
            DsText(
              text: price,
              variant: DsTextVariant.title,
              color: const Color(0xFF10B981),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Observer(builder: (context) {
                final cart = GetIt.instance<CartStore>();
                final isAdded = service != null && cart.contains(service!);

                if (isAdded) {
                  // Match DsButton fixed height (42) and avoid extra vertical padding
                  return SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed:
                          () {}, // keep enabled so styles apply consistently
                      icon:
                          const Icon(Icons.shopping_cart, color: Colors.white),
                      label: const DsText(
                          text: 'Adicionado',
                          variant: DsTextVariant.baseBold,
                          color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        textStyle:
                            const TextStyle(fontSize: 14, height: 20 / 14),
                      ).copyWith(
                        backgroundColor:
                            WidgetStateProperty.all(const Color(0xFF10B981)),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                    ),
                  );
                }

                return DsButton(
                  onPressed: () {
                    if (service != null) {
                      cart.add(service!);
                    }
                    if (onAdd != null) onAdd!();
                  },
                  text: 'Adicionar',
                  variant: DsButtonVariant.primary,
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DsText(
        text: text,
        variant: DsTextVariant.small,
        color: const Color(0xFF1E3A8A),
      ),
    );
  }
}
