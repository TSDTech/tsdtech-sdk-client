import 'package:flutter/material.dart';

import '../../models/cart/cart_item.model.dart';
import '../screens/checkout_screen.dart';
import '../screens/payment_status_screen.dart';
import '../ui/checkout/payment_types.dart';

class TsdtechUi {
  TsdtechUi._();

  static Future<T?> showCheckoutSheet<T>({
    required BuildContext context,
    required List<CartItem> items,
    required String administratorId,
    required VoidCallback onSuccess,
    required VoidCallback onCancel,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          child: CheckoutScreen(
            items: items,
            administratorId: administratorId,
            onSuccess: onSuccess,
            onCancel: onCancel,
          ),
        );
      },
    );
  }

  static Future<T?> showCheckoutDialog<T>({
    required BuildContext context,
    required List<CartItem> items,
    required String administratorId,
    required VoidCallback onSuccess,
    required VoidCallback onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final size = MediaQuery.sizeOf(dialogContext);
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: size.width > 720 ? 680 : size.width,
            height: size.height * 0.9,
            child: CheckoutScreen(
              items: items,
              administratorId: administratorId,
              onSuccess: onSuccess,
              onCancel: onCancel,
            ),
          ),
        );
      },
    );
  }

  static Future<dynamic> pushCheckoutScreen({
    required BuildContext context,
    required List<CartItem> items,
    required String administratorId,
    required VoidCallback onSuccess,
    required VoidCallback onCancel,
  }) {
    return Navigator.of(context).push<void>(
      CheckoutScreen.route(
        items: items,
        administratorId: administratorId,
        onSuccess: onSuccess,
        onCancel: onCancel,
      ),
    );
  }

  static Future<T?> showPaymentStatus<T>({
    required BuildContext context,
    required PaymentResult paymentResult,
    VoidCallback? onRetry,
    VoidCallback? onBack,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final size = MediaQuery.sizeOf(dialogContext);
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: size.width > 640 ? 560 : size.width,
            height: size.height * 0.75,
            child: PaymentStatusScreen(
              paymentResult: paymentResult,
              onRetry: onRetry,
              onBack: onBack,
            ),
          ),
        );
      },
    );
  }
}