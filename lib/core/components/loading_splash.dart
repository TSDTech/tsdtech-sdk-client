import 'package:flutter/material.dart';

/// Polished loading splash used during app startup.
class LoadingSplash extends StatelessWidget {
  final String? message;
  final Widget? indicator;

  const LoadingSplash({this.message, this.indicator, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Card(
              elevation: 18,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28.0, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Image.asset('assets/detran-logo.png',
                          width: 80, height: 80),
                    ),
                    const SizedBox(height: 18),
                    Text(message ?? 'Carregando...',
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF475569))),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 160,
                      child: indicator ??
                          const LinearProgressIndicator(
                              minHeight: 6,
                              color: Color(0xFF2563EB),
                              backgroundColor: Color(0xFFEFF6FF)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
