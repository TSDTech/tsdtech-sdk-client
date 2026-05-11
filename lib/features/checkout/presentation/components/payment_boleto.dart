import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:tsdtech_client_sdk/features/cart/core/stores/cart_store.dart';
import 'package:tsdtech_client_sdk/features/checkout/core/stores/checkout_store.dart';
import 'package:tsdtech_client_sdk/models/checkouts/bill_data.model.dart';

class PaymentBoleto extends StatefulWidget {
  const PaymentBoleto({super.key});

  @override
  State<PaymentBoleto> createState() => _PaymentBoletoState();
}

class _PaymentBoletoState extends State<PaymentBoleto> {
  static const Color _grayText = Color.fromRGBO(107, 114, 128, 1);
  static const Color _blackText = Color.fromRGBO(0, 0, 0, 1);

  BillData? _billData;
  bool _isLoading = true;
  String? _error;
  String? _vencimento;

  CartStore get _cart => GetIt.instance<CartStore>();
  CheckoutStore get _checkout => GetIt.instance<CheckoutStore>();

  @override
  void initState() {
    super.initState();
    _loadBoleto();
  }

  Future<void> _loadBoleto() async {
    if (_cart.items.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Carrinho vazio. Adicione itens para gerar o boleto.';
        });
      }
      return;
    }

    final result = await _checkout.createCheckout(encryptedCard: null);

    if (!mounted) return;

    if (result.isSuccess && result.value?.bill != null) {
      setState(() {
        _billData = result.value!.bill;
        _vencimento = _formatVencimento();
        _isLoading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = false;
      _error = result.error;
    });
  }

  String _formatVencimento() {
    DateTime d = DateTime.now();
    int added = 0;
    while (added < 3) {
      d = d.add(const Duration(days: 1));
      if (d.weekday != DateTime.saturday && d.weekday != DateTime.sunday) {
        added++;
      }
    }
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  void _copiarCodigo() {
    if (_billData == null) return;
    final codeToCopy = _billData!.digitableLine.replaceAll(' ', '');
    Clipboard.setData(ClipboardData(text: codeToCopy));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código copiado!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalFormatted =
        'R\$ ${_cart.total.toStringAsFixed(2).replaceFirst('.', ',')}';

    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: Text(_error!,
            style: const TextStyle(fontSize: 14, color: _grayText)),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1ª linha: Valor do pedido | Vencimento (colunas)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Valor do pedido',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _blackText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalFormatted,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _blackText),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Vencimento',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _blackText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _vencimento ?? 'Em até 3 dias úteis',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _grayText),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Container: Código do Boleto
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Código do Boleto',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _blackText),
                ),
                const SizedBox(height: 8),
                Center(
                  child: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: (_billData?.barCode ?? '')
                        .replaceAll(' ', '')
                        .replaceAll('.', ''),
                    width: double.infinity,
                    height: 56,
                    drawText: false,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  _billData?.digitableLine ?? '',
                  style: const TextStyle(fontSize: 12, color: _grayText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Botão Copiar código
          OutlinedButton.icon(
            onPressed: _billData != null ? _copiarCodigo : null,
            icon: const Icon(Icons.copy, size: 18, color: Colors.black),
            label: const Text('Copiar código',
                style: TextStyle(color: Colors.black)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Colors.black),
              foregroundColor: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Aviso
          const Text(
            'Lembre-se: após o vencimento o boleto não poderá ser pago e seu pedido será cancelado.',
            style: TextStyle(fontSize: 12, color: _grayText, height: 1.4),
          ),
        ],
      ),
    );
  }
}
