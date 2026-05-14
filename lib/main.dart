import 'package:flutter/material.dart';

import 'ui/payment_screen.dart';

void main() {
	runApp(const PaymentStarterApp());
}

class PaymentStarterApp extends StatelessWidget {
	const PaymentStarterApp({super.key});

	@override
	Widget build(BuildContext context) {
		final colorScheme = ColorScheme.fromSeed(
			seedColor: const Color(0xFF0F766E),
			surface: const Color(0xFFF5F7FB),
		);

		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'Pagamento',
			theme: ThemeData(
				colorScheme: colorScheme,
				scaffoldBackgroundColor: const Color(0xFFF5F7FB),
				useMaterial3: true,
				inputDecorationTheme: InputDecorationTheme(
					filled: true,
					fillColor: Colors.white,
					contentPadding: const EdgeInsets.symmetric(
						horizontal: 16,
						vertical: 16,
					),
					border: OutlineInputBorder(
						borderRadius: BorderRadius.circular(16),
						borderSide: BorderSide(color: Colors.grey.shade300),
					),
					enabledBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(16),
						borderSide: BorderSide(color: Colors.grey.shade300),
					),
					focusedBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(16),
						borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
					),
				),
			),
			home: const PaymentScreen(),
		);
	}
}
