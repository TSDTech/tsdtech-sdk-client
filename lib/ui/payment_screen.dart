import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;

                  return isWide
                      ? const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _ScrollableCard(child: _PaymentFormCard())),
                            SizedBox(width: 24),
                            Expanded(flex: 2, child: _ScrollableCard(child: _OrderSummaryCard())),
                          ],
                        )
                      : ListView(
                          children: const [
                            _PaymentFormCard(),
                            SizedBox(height: 24),
                            _OrderSummaryCard(),
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrollableCard extends StatelessWidget {
  const _ScrollableCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: child,
    );
  }
}

class _PaymentFormCard extends StatefulWidget {
  const _PaymentFormCard();

  @override
  State<_PaymentFormCard> createState() => _PaymentFormCardState();
}

class _PaymentFormCardState extends State<_PaymentFormCard> {
  final _formKey = GlobalKey<FormState>();
  String _selectedMethod = 'Cartao de credito';
  String _selectedInstallment = '1x de R\$ 249,90';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pagamento',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Preencha os dados abaixo para concluir a compra.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 28),
            _buildSectionTitle(context, 'Metodo de pagamento'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedMethod,
              items: const [
                DropdownMenuItem(
                  value: 'Cartao de credito',
                  child: Text('Cartao de credito'),
                ),
                DropdownMenuItem(
                  value: 'Pix',
                  child: Text('Pix'),
                ),
                DropdownMenuItem(
                  value: 'Boleto',
                  child: Text('Boleto'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedMethod = value);
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Dados do titular'),
            const SizedBox(height: 12),
            const _ResponsiveFields(
              children: [
                _FieldSpec(label: 'Nome completo'),
                _FieldSpec(label: 'E-mail'),
                _FieldSpec(label: 'CPF'),
                _FieldSpec(label: 'Telefone'),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Dados do cartao'),
            const SizedBox(height: 12),
            const _ResponsiveFields(
              children: [
                _FieldSpec(label: 'Numero do cartao', flex: 2),
                _FieldSpec(label: 'Validade'),
                _FieldSpec(label: 'CVV'),
              ],
            ),
            const SizedBox(height: 16),
            const _ResponsiveFields(
              children: [
                _FieldSpec(label: 'Nome impresso no cartao', flex: 2),
                _FieldSpec(label: 'Parcelas'),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedInstallment,
              items: const [
                DropdownMenuItem(
                  value: '1x de R\$ 249,90',
                  child: Text('1x de R\$ 249,90 sem juros'),
                ),
                DropdownMenuItem(
                  value: '2x de R\$ 124,95',
                  child: Text('2x de R\$ 124,95 sem juros'),
                ),
                DropdownMenuItem(
                  value: '3x de R\$ 83,30',
                  child: Text('3x de R\$ 83,30 sem juros'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedInstallment = value);
              },
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                'Estrutura inicial pronta para conectar com tokenizacao do cartao, criacao do checkout e confirmacao de pagamento.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF475569),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x221D4ED8),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo da compra',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Visao simples para iniciar a experiencia de checkout.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 28),
          const _SummaryLine(
            title: 'Produto',
            value: 'Plano Premium Anual',
          ),
          const SizedBox(height: 16),
          const _SummaryLine(
            title: 'Licencas',
            value: '1 usuario',
          ),
          const SizedBox(height: 16),
          const _SummaryLine(
            title: 'Subtotal',
            value: 'R\$ 229,90',
          ),
          const SizedBox(height: 16),
          const _SummaryLine(
            title: 'Taxa de processamento',
            value: 'R\$ 20,00',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Divider(color: Colors.white24, height: 1),
          ),
          Text(
            'Total',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'R\$ 249,90',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0F172A),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('Finalizar pagamento'),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lock_outline, color: Colors.white70, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ambiente preparado para integrar a captura segura dos dados de pagamento.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveFields extends StatelessWidget {
  const _ResponsiveFields({required this.children});

  final List<_FieldSpec> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 640;

        if (isCompact) {
          return Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                _PaymentTextField(label: children[index].label),
                if (index < children.length - 1) const SizedBox(height: 16),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              Expanded(
                flex: children[index].flex,
                child: _PaymentTextField(label: children[index].label),
              ),
              if (index < children.length - 1) const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }
}

class _FieldSpec {
  const _FieldSpec({required this.label, this.flex = 1});

  final String label;
  final int flex;
}

class _PaymentTextField extends StatelessWidget {
  const _PaymentTextField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}