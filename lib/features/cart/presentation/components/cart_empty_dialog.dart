import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';

/// Shows an anchored empty-cart popup.
///
/// On wide screens it appears near the top-right (anchored), on small screens it
/// is centered like a standard dialog.
void showCartEmptyDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cart empty',
    barrierColor: Colors.black.withOpacity(0.25),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (ctx, anim1, anim2) {
      // Use the page-builder's ctx to ensure Navigator.pop works on this route.
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(ctx).maybePop(),
        child: const SafeArea(
          child: _CartEmptyOverlay(),
        ),
      );
    },
    transitionBuilder: (ctx, anim1, anim2, child) {
      return FadeTransition(opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut), child: child);
    },
  );
}

class _CartEmptyOverlay extends StatelessWidget {
  const _CartEmptyOverlay();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isMobile = mq.size.width < 600;

    // Overlay background to dim behind
    Widget content = Material(
      color: Colors.transparent,
      child: Align(
        alignment: isMobile ? Alignment.center : Alignment.topRight,
        child: Padding(
          padding: isMobile ? const EdgeInsets.symmetric(horizontal: 24, vertical: 48) : const EdgeInsets.only(top: 88, right: 24),
          child: Container(
            width: isMobile ? double.infinity : 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 18)],
            ),
            padding: const EdgeInsets.all(20),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CartEmptyContent(),
              ],
            ),
          ),
        ),
      ),
    );

    return Stack(
      children: [
        // dim background
        GestureDetector(onTap: () => Navigator.of(context).pop(), child: Container(color: Colors.black.withOpacity(0.25))),
        content,
      ],
    );
  }
}

class _CartEmptyContent extends StatelessWidget {
  const _CartEmptyContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF9CA3AF), size: 36),
        ),
        const SizedBox(height: 12),
        const DsText(text: 'Seu carrinho está vazio', variant: DsTextVariant.baseBold),
        const SizedBox(height: 8),
        const DsText(text: 'Adicione serviços do catálogo para começar.', variant: DsTextVariant.small, color: Color(0xFF6B7280)),
      ],
    );
  }
}

