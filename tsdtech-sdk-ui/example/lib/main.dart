import 'package:flutter/material.dart';
import 'package:tsdtech_sdk_ui/tsdtech_sdk_ui.dart';

void main() {
  TsdtechUiConfig.initialize(
    baseUrl: 'https://api.example.com',
    apiKey: 'demo-api-key',
    locale: TsdtechLocale.pt,
  );

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = TsdtechUiConfig.instance.theme;

    return MaterialApp(
      title: 'TSDTech SDK UI – Example',
      debugShowCheckedModeBanner: false,
      theme: themeData.toMaterialTheme(),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  bool _useDark = false;

  void _toggleTheme() {
    TsdtechUiConfig.initialize(
      baseUrl: TsdtechUiConfig.instance.baseUrl,
      apiKey: TsdtechUiConfig.instance.apiKey,
      theme: _useDark ? TsdtechThemeData.dark() : TsdtechThemeData.light(),
      locale: TsdtechUiConfig.instance.locale,
    );
    setState(() => _useDark = !_useDark);
  }

  @override
  Widget build(BuildContext context) {
    final theme = TsdtechUiConfig.instance.theme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('TSDTech SDK UI'),
        actions: [
          IconButton(
            icon: Icon(_useDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: 'Configuração',
              child: _ConfigCard(theme: theme),
            ),
            const SizedBox(height: 24),
            _Section(
              title: 'Paleta de Cores',
              child: _ColorPalette(theme: theme),
            ),
            const SizedBox(height: 24),
            _Section(
              title: 'Tipografia',
              child: _TypographySamples(theme: theme),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper widgets
// ---------------------------------------------------------------------------

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TsdtechTextStyles.overline,
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ConfigCard extends StatelessWidget {
  const _ConfigCard({required this.theme});

  final TsdtechThemeData theme;

  @override
  Widget build(BuildContext context) {
    final config = TsdtechUiConfig.instance;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Row('baseUrl', config.baseUrl),
            _Row('apiKey', config.apiKey ?? '—'),
            _Row('locale', config.locale.name),
            _Row('brightness', theme.brightness.name),
            _Row('borderRadius', theme.borderRadius.toString()),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TsdtechTextStyles.labelMedium),
          ),
          Expanded(child: Text(value, style: TsdtechTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

class _ColorPalette extends StatelessWidget {
  const _ColorPalette({required this.theme});

  final TsdtechThemeData theme;

  @override
  Widget build(BuildContext context) {
    final swatches = <String, Color>{
      'primary': theme.primaryColor,
      'primaryLight': theme.primaryLightColor,
      'accent': theme.accentColor,
      'surface': theme.surfaceColor,
      'outline': theme.outlineColor,
      'success': theme.successColor,
      'warning': theme.warningColor,
      'error': theme.errorColor,
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: swatches.entries.map((e) {
        return Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: e.value,
                borderRadius: BorderRadius.circular(theme.borderRadius),
                border: Border.all(color: TsdtechColors.outline),
              ),
            ),
            const SizedBox(height: 4),
            Text(e.key, style: TsdtechTextStyles.caption),
          ],
        );
      }).toList(),
    );
  }
}

class _TypographySamples extends StatelessWidget {
  const _TypographySamples({required this.theme});

  final TsdtechThemeData theme;

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Headline Large', style: TsdtechTextStyles.headlineLarge),
            Text('Headline Medium', style: TsdtechTextStyles.headlineMedium),
            Text('Title Large', style: TsdtechTextStyles.titleLarge),
            Text('Body Large — Texto de exemplo', style: TsdtechTextStyles.bodyLarge),
            Text('Body Medium — Texto de exemplo', style: TsdtechTextStyles.bodyMedium),
            Text('Label Medium', style: TsdtechTextStyles.labelMedium),
            Text('CAPTION', style: TsdtechTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
