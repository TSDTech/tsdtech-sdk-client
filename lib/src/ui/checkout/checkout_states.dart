import 'package:flutter/material.dart';

class CheckoutLoadingState extends StatelessWidget {
  final Widget? customLoading;
  const CheckoutLoadingState({super.key, this.customLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: customLoading ?? const CircularProgressIndicator(),
    );
  }
}

class CheckoutErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final Widget? customError;

  const CheckoutErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.customError,
  });

  @override
  Widget build(BuildContext context) {
    if (customError != null) return customError!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: onRetry, child: const Text('Tentar Novamente')),
        ],
      ),
    );
  }
}
