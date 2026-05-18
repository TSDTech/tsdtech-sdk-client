import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

void main() {
	_configureDemoTheme(DemoThemePreset.brand);
	runApp(const ExampleApp());
}

enum DemoThemePreset { brand, ocean, graphite }

void _configureDemoTheme(DemoThemePreset preset) {
	TsdtechUiConfig.initialize(
		baseUrl: Constants.getBaseUrl(),
		gatewayBaseUrl: Constants.getBaseUrl(),
		apiKey: 'demo-api-key',
		locale: TsdtechLocale.pt,
		theme: _themeForPreset(preset),
	);
}

TsdtechThemeData _themeForPreset(DemoThemePreset preset) {
	switch (preset) {
		case DemoThemePreset.brand:
			return TsdtechThemeData.light();
		case DemoThemePreset.ocean:
			return TsdtechThemeData.light().copyWith(
				primaryColor: const Color(0xFF005F73),
				primaryLightColor: const Color(0xFF0A9396),
				primaryDarkColor: const Color(0xFF003845),
				accentColor: const Color(0xFFEE9B00),
				surfaceVariantColor: const Color(0xFFE7F4F4),
				outlineColor: const Color(0xFFB8D3D4),
				borderRadius: 18,
				fontFamily: 'Open Sans',
			);
		case DemoThemePreset.graphite:
			return TsdtechThemeData.dark().copyWith(
				primaryColor: const Color(0xFFFF7A59),
				primaryLightColor: const Color(0xFFFFB199),
				primaryDarkColor: const Color(0xFFE85D3A),
				accentColor: const Color(0xFFFFD166),
				backgroundColor: const Color(0xFF121417),
				surfaceColor: const Color(0xFF1C2025),
				surfaceVariantColor: const Color(0xFF242A31),
				outlineColor: const Color(0xFF3C4450),
				textPrimaryColor: const Color(0xFFF5F7FA),
				textSecondaryColor: const Color(0xFFBCC4CF),
				textDisabledColor: const Color(0xFF717B88),
				borderRadius: 22,
				fontFamily: 'Open Sans',
			);
	}
}

class ExampleApp extends StatefulWidget {
	const ExampleApp({super.key});

	@override
	State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
	DemoThemePreset _preset = DemoThemePreset.brand;

	void _setPreset(DemoThemePreset preset) {
		setState(() {
			_preset = preset;
			_configureDemoTheme(preset);
		});
	}

	@override
	Widget build(BuildContext context) {
		final theme = TsdtechUiConfig.instance.theme;

		return MaterialApp(
			title: 'TSDTech SDK Example',
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
			localizationsDelegates: GlobalMaterialLocalizations.delegates,
			supportedLocales: const [
				Locale('pt', 'BR'),
				Locale('en'),
				Locale('es'),
			],
			home: ExampleHomePage(
				preset: _preset,
				onPresetChanged: _setPreset,
			),
		);
	}
}

class ExampleHomePage extends StatefulWidget {
	const ExampleHomePage({
		super.key,
		required this.preset,
		required this.onPresetChanged,
	});

	final DemoThemePreset preset;
	final ValueChanged<DemoThemePreset> onPresetChanged;

	@override
	State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
	static const _administratorId = 'admin_demo_123';
	static const _gatewayPublicKey = '''-----BEGIN PUBLIC KEY-----
MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAK0M-demo-key-for-example-only-12345
67890abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZIDAQAB
-----END PUBLIC KEY-----''';

	late final List<CartItem> _demoItems = [
		CartItem(
			service: Service(
				id: 'svc_haircut',
				name: 'Corte premium',
				description: 'Atendimento com finalização e consultoria rápida.',
				administratorId: _administratorId,
				price: 89.9,
			),
			quantity: 1,
		),
		CartItem(
			service: Service(
				id: 'svc_beard',
				name: 'Barba express',
				description: 'Modelagem simples com toalha quente.',
				administratorId: _administratorId,
				price: 35.0,
			),
			quantity: 1,
		),
	];

	final CheckoutStore _checkoutStore = CheckoutStore();
	final PaymentStore _paymentStore = PaymentStore();
	final CardFormStore _cardFormStore = CardFormStore();

	PaymentFormData? _paymentFormResult;
	CardFormData? _cardPreview;
	PaymentStatus? _checkoutStatus;

	double get _total {
		return _demoItems.fold<double>(
			0,
			(sum, item) => sum + (item.service.price ?? 0) * item.quantity,
		);
	}

	void _showMessage(String message) {
		ScaffoldMessenger.of(context).showSnackBar(
			SnackBar(content: Text(message)),
		);
	}

	Future<void> _openCheckoutScreen() async {
		await Navigator.of(context).push(
			CheckoutScreen.route(
				items: _demoItems,
				administratorId: _administratorId,
				onSuccess: () => _showMessage('CheckoutScreen concluiu o fluxo.'),
				onCancel: () => _showMessage('CheckoutScreen encerrada pelo usuário.'),
			),
		);
	}

	@override
	void dispose() {
		_checkoutStore.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final theme = TsdtechUiConfig.instance.theme;
		final isWide = MediaQuery.sizeOf(context).width >= 980;

		return Scaffold(
			appBar: AppBar(
				title: const Text('TSDTech SDK Example'),
			),
			body: DecoratedBox(
				decoration: BoxDecoration(
					gradient: LinearGradient(
						begin: Alignment.topLeft,
						end: Alignment.bottomRight,
						colors: [
							theme.backgroundColor,
							theme.surfaceVariantColor,
						],
					),
				),
				child: SafeArea(
					child: SingleChildScrollView(
						padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								_HeroSection(
									total: _total,
									itemCount: _demoItems.length,
									preset: widget.preset,
									onPresetChanged: widget.onPresetChanged,
									onOpenScreen: _openCheckoutScreen,
								),
								const SizedBox(height: 20),
								_SectionCard(
									title: 'Uso básico com CheckoutWidget',
									subtitle:
											'Exibe o widget direto no layout da sua app. O botão do CheckoutWidget usa os dados do carrinho de demonstração.',
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											_CartPreview(items: _demoItems, total: _total),
											const SizedBox(height: 20),
											CheckoutWidget(
												store: _checkoutStore,
												items: _demoItems,
												administratorId: _administratorId,
												gatewayPublicKey: _gatewayPublicKey,
												onStatusChange: (status) {
													setState(() => _checkoutStatus = status);
												},
												onSuccess: (result) {
													_showMessage(
														'Pagamento ${result.method.name} finalizado: ${result.transactionId}',
													);
												},
												onError: (message) {
													_showMessage('CheckoutWidget retornou erro: $message');
												},
											),
											const SizedBox(height: 16),
											_StatusBanner(status: _checkoutStatus),
										],
									),
								),
								const SizedBox(height: 20),
								_SectionCard(
									title: 'Uso de telas com CheckoutScreen',
									subtitle:
											'Abre o fluxo completo em uma rota dedicada, útil quando você quer separar resumo do pedido e ação de pagamento.',
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											const Wrap(
												spacing: 12,
												runSpacing: 12,
												children: [
													_FeatureChip(label: 'Navegação pronta'),
													_FeatureChip(label: 'Resumo do pedido'),
													_FeatureChip(label: 'Controle de loading'),
													_FeatureChip(label: 'Tratamento de chave pública'),
												],
											),
											const SizedBox(height: 16),
											FilledButton.icon(
												onPressed: _openCheckoutScreen,
												icon: const Icon(Icons.open_in_new_rounded),
												label: const Text('Abrir CheckoutScreen'),
											),
										],
									),
								),
								const SizedBox(height: 20),
								isWide
										? Row(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Expanded(child: _buildStandaloneFormsSection()),
													const SizedBox(width: 20),
													Expanded(child: _buildThemeSection()),
												],
											)
										: Column(
												children: [
													_buildStandaloneFormsSection(),
													const SizedBox(height: 20),
													_buildThemeSection(),
												],
											),
							],
						),
					),
				),
			),
		);
	}

	Widget _buildStandaloneFormsSection() {
		return _SectionCard(
			title: 'Formulários isolados',
			subtitle:
					'Use os blocos separadamente quando o fluxo de pagamento precisa ser encaixado em uma experiência própria.',
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					PaymentForm(
						store: _paymentStore,
						submitLabel: 'Simular envio',
						onSubmit: (data) {
							setState(() => _paymentFormResult = data);
							_showMessage(
								data.isCard
										? 'PaymentForm enviou cartão de ${data.cardData?.cardholderName ?? 'titular não informado'}.'
										: 'PaymentForm enviou PIX.',
							);
						},
					),
					const SizedBox(height: 16),
					_InfoTile(
						title: 'Último resultado do PaymentForm',
						content: _paymentFormResult == null
								? 'Nenhum submit ainda.'
								: _paymentFormResult!.isCard
										? 'Método: cartão\nTitular: ${_paymentFormResult!.cardData?.cardholderName ?? '-'}\nBandeira: ${_paymentFormResult!.cardData?.brand.name ?? 'unknown'}'
										: 'Método: PIX',
					),
					const SizedBox(height: 20),
					CardForm(
						store: _cardFormStore,
						submitLabel: 'Validar cartão',
						onChanged: (data) {
							setState(() => _cardPreview = data);
						},
						onSubmit: (data) {
							setState(() => _cardPreview = data);
							_showMessage('CardForm validou ${data.brand.name.toUpperCase()}.');
						},
					),
					const SizedBox(height: 16),
					_InfoTile(
						title: 'Preview do CardForm',
						content: _cardPreview == null
								? 'Preencha o formulário para visualizar a saída capturada.'
								: 'Titular: ${_cardPreview!.cardholderName}\nBandeira: ${_cardPreview!.brand.name}\nDocumento: ${_cardPreview!.taxId}',
					),
					const SizedBox(height: 20),
					PixDisplay(
						pixData: PixData(
							qrCode:
									'00020126580014BR.GOV.BCB.PIX0136123e4567-e89b-12d3-a456-4266141740005204000053039865405123.455802BR5925TSDTECH SDK EXAMPLE6009SAO PAULO62070503***6304A1B2',
							copyPasteCode:
									'00020126580014BR.GOV.BCB.PIX0136123e4567-e89b-12d3-a456-4266141740005204000053039865405123.455802BR5925TSDTECH SDK EXAMPLE6009SAO PAULO62070503***6304A1B2',
						),
						expiresAt: DateTime.now().add(const Duration(minutes: 25)),
						onCopied: () => _showMessage('Código PIX copiado.'),
					),
				],
			),
		);
	}

	Widget _buildThemeSection() {
		final theme = TsdtechUiConfig.instance.theme;

		return _SectionCard(
			title: 'Customização de tema',
			subtitle:
					'O app reconfigura TsdtechUiConfig em tempo real para mostrar como o SDK se adapta a diferentes marcas.',
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					Wrap(
						spacing: 12,
						runSpacing: 12,
						children: DemoThemePreset.values.map((preset) {
							final isSelected = widget.preset == preset;
							return ChoiceChip(
								label: Text(_presetLabel(preset)),
								selected: isSelected,
								onSelected: (_) => widget.onPresetChanged(preset),
							);
						}).toList(),
					),
					const SizedBox(height: 20),
					Container(
						padding: const EdgeInsets.all(16),
						decoration: BoxDecoration(
							color: theme.surfaceVariantColor,
							borderRadius: BorderRadius.circular(theme.borderRadius),
							border: Border.all(color: theme.outlineColor),
						),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									'Configuração ativa',
									style: Theme.of(context).textTheme.titleMedium,
								),
								const SizedBox(height: 12),
								_PaletteRow(label: 'Base URL', value: TsdtechUiConfig.instance.baseUrl),
								_PaletteRow(label: 'Preset', value: _presetLabel(widget.preset)),
								_PaletteRow(label: 'Brightness', value: theme.brightness.name),
								_PaletteRow(label: 'Border radius', value: theme.borderRadius.toStringAsFixed(0)),
								_PaletteRow(label: 'Font family', value: theme.fontFamily ?? 'system'),
							],
						),
					),
					const SizedBox(height: 20),
					Wrap(
						spacing: 12,
						runSpacing: 12,
						children: [
							_ColorSwatchCard(label: 'Primary', color: theme.primaryColor),
							_ColorSwatchCard(label: 'Accent', color: theme.accentColor),
							_ColorSwatchCard(label: 'Surface', color: theme.surfaceColor),
							_ColorSwatchCard(label: 'Background', color: theme.backgroundColor),
						],
					),
				],
			),
		);
	}
}

String _presetLabel(DemoThemePreset preset) {
	switch (preset) {
		case DemoThemePreset.brand:
			return 'Brand';
		case DemoThemePreset.ocean:
			return 'Ocean';
		case DemoThemePreset.graphite:
			return 'Graphite';
	}
}

class _HeroSection extends StatelessWidget {
	const _HeroSection({
		required this.total,
		required this.itemCount,
		required this.preset,
		required this.onPresetChanged,
		required this.onOpenScreen,
	});

	final double total;
	final int itemCount;
	final DemoThemePreset preset;
	final ValueChanged<DemoThemePreset> onPresetChanged;
	final VoidCallback onOpenScreen;

	@override
	Widget build(BuildContext context) {
		final theme = TsdtechUiConfig.instance.theme;

		return Container(
			padding: const EdgeInsets.all(24),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(theme.borderRadius + 6),
				gradient: LinearGradient(
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
					colors: [
						theme.primaryColor,
						theme.primaryLightColor,
					],
				),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(
						'Exemplo completo do SDK',
						style: Theme.of(context).textTheme.headlineSmall?.copyWith(
									color: theme.textOnPrimaryColor,
									fontWeight: FontWeight.w700,
								),
					),
					const SizedBox(height: 8),
					Text(
						'Este app reúne o CheckoutWidget, a CheckoutScreen, os formulários isolados e a troca de tema em uma única vitrine executável.',
						style: Theme.of(context).textTheme.bodyLarge?.copyWith(
									color: theme.textOnPrimaryColor.withOpacity(0.9),
								),
					),
					const SizedBox(height: 20),
					Wrap(
						spacing: 12,
						runSpacing: 12,
						children: [
							_HeroMetric(label: 'Itens', value: '$itemCount'),
							_HeroMetric(label: 'Total demo', value: 'R\$ ${total.toStringAsFixed(2)}'),
							_HeroMetric(label: 'Tema', value: _presetLabel(preset)),
						],
					),
					const SizedBox(height: 20),
					Wrap(
						spacing: 12,
						runSpacing: 12,
						children: [
							FilledButton.icon(
								onPressed: onOpenScreen,
								style: FilledButton.styleFrom(
									backgroundColor: theme.textOnPrimaryColor,
									foregroundColor: theme.primaryDarkColor,
								),
								icon: const Icon(Icons.shopping_bag_outlined),
								label: const Text('Abrir fluxo em tela cheia'),
							),
							OutlinedButton.icon(
								onPressed: () {
									final next = DemoThemePreset
											.values[(preset.index + 1) % DemoThemePreset.values.length];
									onPresetChanged(next);
								},
								style: OutlinedButton.styleFrom(
									foregroundColor: theme.textOnPrimaryColor,
									side: BorderSide(color: theme.textOnPrimaryColor.withOpacity(0.4)),
								),
								icon: const Icon(Icons.palette_outlined),
								label: const Text('Trocar tema'),
							),
						],
					),
				],
			),
		);
	}
}

class _HeroMetric extends StatelessWidget {
	const _HeroMetric({required this.label, required this.value});

	final String label;
	final String value;

	@override
	Widget build(BuildContext context) {
		final theme = TsdtechUiConfig.instance.theme;

		return Container(
			width: 150,
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: Colors.white.withOpacity(0.14),
				borderRadius: BorderRadius.circular(18),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(
						label,
						style: Theme.of(context).textTheme.bodySmall?.copyWith(
									color: theme.textOnPrimaryColor.withOpacity(0.8),
								),
					),
					const SizedBox(height: 8),
					Text(
						value,
						style: Theme.of(context).textTheme.titleLarge?.copyWith(
									color: theme.textOnPrimaryColor,
									fontWeight: FontWeight.w700,
								),
					),
				],
			),
		);
	}
}

class _SectionCard extends StatelessWidget {
	const _SectionCard({
		required this.title,
		required this.subtitle,
		required this.child,
	});

	final String title;
	final String subtitle;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final theme = TsdtechUiConfig.instance.theme;

		return Card(
			child: Padding(
				padding: const EdgeInsets.all(20),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(title, style: Theme.of(context).textTheme.titleLarge),
						const SizedBox(height: 8),
						Text(
							subtitle,
							style: Theme.of(context).textTheme.bodyMedium?.copyWith(
										color: theme.textSecondaryColor,
									),
						),
						const SizedBox(height: 20),
						child,
					],
				),
			),
		);
	}
}

class _CartPreview extends StatelessWidget {
	const _CartPreview({required this.items, required this.total});

	final List<CartItem> items;
	final double total;

	@override
	Widget build(BuildContext context) {
		final theme = TsdtechUiConfig.instance.theme;

		return Container(
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: theme.surfaceVariantColor,
				borderRadius: BorderRadius.circular(theme.borderRadius),
			),
			child: Column(
				children: [
					for (final item in items)
						Padding(
							padding: const EdgeInsets.only(bottom: 12),
							child: Row(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Expanded(
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Text(
													item.service.name ?? 'Serviço sem nome',
													style: Theme.of(context).textTheme.titleMedium,
												),
												if (item.service.description?.isNotEmpty == true)
													Padding(
														padding: const EdgeInsets.only(top: 4),
														child: Text(
															item.service.description!,
															style: Theme.of(context).textTheme.bodySmall,
														),
													),
											],
										),
									),
									Text('x${item.quantity}'),
									const SizedBox(width: 16),
									Text(
										'R\$ ${((item.service.price ?? 0) * item.quantity).toStringAsFixed(2)}',
										style: Theme.of(context).textTheme.titleSmall,
									),
								],
							),
						),
					const Divider(height: 24),
					Row(
						children: [
							const Expanded(child: Text('Total do carrinho demo')),
							Text(
								'R\$ ${total.toStringAsFixed(2)}',
								style: Theme.of(context).textTheme.titleMedium,
							),
						],
					),
				],
			),
		);
	}
}

class _StatusBanner extends StatelessWidget {
	const _StatusBanner({required this.status});

	final PaymentStatus? status;

	@override
	Widget build(BuildContext context) {
		final theme = TsdtechUiConfig.instance.theme;

		if (status == null) {
			return const _InfoTile(
				title: 'Status do CheckoutWidget',
				content: 'Nenhuma ação executada ainda.',
			);
		}

		final map = switch (status!) {
			PaymentStatus.processing => ('Processando', theme.warningColor),
			PaymentStatus.waitingPayment => ('Aguardando pagamento', theme.accentColor),
			PaymentStatus.success => ('Concluído', theme.successColor),
			PaymentStatus.failed => ('Falhou', theme.errorColor),
		};

		return Container(
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: map.$2.withOpacity(0.12),
				borderRadius: BorderRadius.circular(theme.borderRadius),
				border: Border.all(color: map.$2.withOpacity(0.32)),
			),
			child: Row(
				children: [
					Icon(Icons.info_outline_rounded, color: map.$2),
					const SizedBox(width: 12),
					Expanded(
						child: Text(
							'Status atual: ${map.$1}',
							style: Theme.of(context).textTheme.bodyMedium,
						),
					),
				],
			),
		);
	}
}

class _InfoTile extends StatelessWidget {
	const _InfoTile({required this.title, required this.content});

	final String title;
	final String content;

	@override
	Widget build(BuildContext context) {
		final theme = TsdtechUiConfig.instance.theme;

		return Container(
			width: double.infinity,
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: theme.surfaceVariantColor,
				borderRadius: BorderRadius.circular(theme.borderRadius),
				border: Border.all(color: theme.outlineColor),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(title, style: Theme.of(context).textTheme.titleSmall),
					const SizedBox(height: 8),
					Text(content, style: Theme.of(context).textTheme.bodyMedium),
				],
			),
		);
	}
}

class _FeatureChip extends StatelessWidget {
	const _FeatureChip({required this.label});

	final String label;

	@override
	Widget build(BuildContext context) {
		return Chip(label: Text(label));
	}
}

class _PaletteRow extends StatelessWidget {
	const _PaletteRow({required this.label, required this.value});

	final String label;
	final String value;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(vertical: 4),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					SizedBox(
						width: 110,
						child: Text(label, style: Theme.of(context).textTheme.bodySmall),
					),
					Expanded(
						child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
					),
				],
			),
		);
	}
}

class _ColorSwatchCard extends StatelessWidget {
	const _ColorSwatchCard({required this.label, required this.color});

	final String label;
	final Color color;

	@override
	Widget build(BuildContext context) {
		return Container(
			width: 150,
			padding: const EdgeInsets.all(14),
			decoration: BoxDecoration(
				color: Theme.of(context).cardColor,
				borderRadius: BorderRadius.circular(16),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Container(
						height: 56,
						decoration: BoxDecoration(
							color: color,
							borderRadius: BorderRadius.circular(12),
						),
					),
					const SizedBox(height: 10),
					Text(label, style: Theme.of(context).textTheme.titleSmall),
					const SizedBox(height: 4),
					Text(
						'#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
						style: Theme.of(context).textTheme.bodySmall,
					),
				],
			),
		);
	}
}
