import 'package:flutter/material.dart';

class CheckoutSuccessState extends StatelessWidget {
  final Widget? customSuccess;
  final String? message;
  const CheckoutSuccessState({super.key, this.customSuccess, this.message});

  @override
  Widget build(BuildContext context) {
    if (customSuccess != null) return customSuccess!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
          const SizedBox(height: 12),
          Text(
            message ?? 'Pagamento realizado com sucesso!',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
