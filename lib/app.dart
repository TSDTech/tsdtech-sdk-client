import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tsdtech_client_sdk/src/screens/demo_screen.dart';
import 'package:tsdtech_client_sdk/src/ui/config/tsdtech_ui_config.dart';

class TsdtechApp extends StatelessWidget {
  const TsdtechApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Puxa o tema oficial que foi inicializado no main
    final theme = TsdtechUiConfig.instance.theme;

    return MaterialApp(
      title: 'TSDTech SDK',
      debugShowCheckedModeBanner: false,
      theme: theme.toMaterialTheme().copyWith(
        scaffoldBackgroundColor: theme.backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: theme.backgroundColor,
          foregroundColor: theme.textPrimaryColor,
          elevation: 0,
          centerTitle: false,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: theme.surfaceVariantColor,
          selectedColor: theme.primaryColor,
          labelStyle: TextStyle(color: theme.textPrimaryColor),
          secondaryLabelStyle: TextStyle(color: theme.textOnPrimaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
            side: BorderSide(color: theme.outlineColor),
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: const DemoScreen(), // Chama a tela de teste
    );
  }
}
