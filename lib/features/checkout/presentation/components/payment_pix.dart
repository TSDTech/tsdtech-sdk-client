import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:voucherize/core/router/router.dart';
import 'package:voucherize/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:voucherize/features/cart/core/stores/cart_store.dart';
import 'package:voucherize/features/checkout/core/stores/checkout_store.dart';
import 'package:voucherize/models/checkouts/calculate_item.model.dart';
import 'package:voucherize/models/checkouts/checkout_request.model.dart';
import 'package:voucherize/models/checkouts/pix_data.model.dart';

class PaymentPix extends StatefulWidget {
  const PaymentPix({super.key});

  @override
  State<PaymentPix> createState() => _PaymentPixState();
}

class _PaymentPixState extends State<PaymentPix> {
  static const Color _grayText = Color.fromRGBO(107, 114, 128, 1);
  static const Color _greenValue = Color.fromRGBO(22, 163, 74, 1);

  PixData? _pixData;
  String? _paymentId;
  bool _isLoading = true;
  String? _error;
  bool _isPolling = false;
  Timer? _pollTimer;
  int _pollCount = 0;
  static const int _maxPollAttempts = 300;

  CartStore get _cart => GetIt.instance<CartStore>();
  CheckoutStore get _checkout => GetIt.instance<CheckoutStore>();
  CheckoutsService get _checkoutsService => CheckoutsService.instance;

  @override
  void initState() {
    super.initState();
    _createPixCheckout();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _pollTimer = null;
    super.dispose();
  }

  Future<void> _createPixCheckout() async {
    if (_cart.items.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Carrinho vazio. Adicione itens para gerar o Pix.';
        });
      }
      return;
    }

    final cartItems = _cart.items
        .map((cartItem) => CalculateItem(
              serviceId: cartItem.service.id ?? '',
              value: cartItem.service.price ?? 0.0,
              quantity: cartItem.quantity,
            ))
        .toList();
    final request = CheckoutRequest(
      cart: cartItems,
      paymentMethod: 'PIX',
      totalValue: _checkout.total,
      encryptedCard: null,
    );

    final result = await _checkoutsService.createCheckout(request);

    if (!mounted) return;

    if (result.isSuccess && result.value != null) {
      final response = result.value!;
      final pix = response.pix;
      final paymentId = response.paymentId;

      print(paymentId);

      if (pix != null && paymentId != null && paymentId.isNotEmpty) {
        setState(() {
          _pixData = pix;
          _paymentId = paymentId;
          _isLoading = false;
          _error = null;
          _isPolling = true;
        });
        _startPolling();
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Não foi possível gerar o Pix. Tente novamente.';
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _error = result.error.toString();
      });
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollCount = 0;

    void checkStatus() async {
      if (_paymentId == null || !mounted) return;
      if (_pollCount >= _maxPollAttempts) {
        if (mounted) {
          setState(() {
            _isPolling = false;
            _error = 'Tempo esgotado. Tente novamente.';
          });
        }
        _pollTimer?.cancel();
        return;
      }

      _pollCount++;
      final result = await _checkoutsService.getPixStatus(_paymentId!);

      if (!mounted) return;

      if (result.isSuccess && result.value != null) {
        final status = (result.value as String).toUpperCase();
        if (status == 'PAID') {
          _pollTimer?.cancel();
          _pollTimer = null;
          setState(() => _isPolling = false);
          _cart.clear();
          if (mounted) {
            AutoRouter.of(context).replaceAll([const PurchaseHistoryRoute()]);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Checkout criado com sucesso!')),
            );
          }
          return;
        }
      }

      _pollTimer = Timer(const Duration(seconds: 2), checkStatus);
    }

    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    final totalFormatted =
        'R\$ ${_cart.total.toStringAsFixed(2).replaceFirst('.', ',')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.smartphone, size: 20, color: _grayText),
              const SizedBox(width: 8),
              Text(
                'Aponte a câmera do seu celular',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: _grayText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            Center(
              child: Container(
                width: 140,
                height: 140,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          else if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: _grayText),
                ),
              ),
            )
          else if (_pixData != null) ...[
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE6EEF9)),
                ),
                child: QrImageView(
                  data: _pixData!.copyPasteCode,
                  version: QrVersions.auto,
                  size: 140,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
            // if (_isPolling) ...[
            //   const SizedBox(height: 8),
            //   Center(
            //     child: Text(
            //       'Aguardando confirmação do pagamento...',
            //       style: TextStyle(fontSize: 12, color: _grayText),
            //     ),
            //   ),
            // ],
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Valor no Pix:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _grayText,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                totalFormatted,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _greenValue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
