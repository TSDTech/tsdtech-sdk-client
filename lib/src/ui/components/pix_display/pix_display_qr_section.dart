import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

import '../../theme/tsdtech_colors.dart';
import '../../theme/tsdtech_text_styles.dart';

class PixQrSection extends StatelessWidget {
  const PixQrSection({
    super.key,
    required this.pixData,
    required this.qrSize,
    required this.expired,
  });

  final PixData pixData;
  final double qrSize;
  final bool expired;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Escaneie o QR Code para pagar',
            style: TsdtechTextStyles.titleSmall.copyWith(
              color: TsdtechColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: TsdtechColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: TsdtechColors.outline),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: expired
                ? ExpiredQrOverlay(size: qrSize)
                : QrImageView(
                    data: pixData.qrCode,
                    version: QrVersions.auto,
                    size: qrSize,
                    backgroundColor: TsdtechColors.white,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: TsdtechColors.textPrimary,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: TsdtechColors.textPrimary,
                    ),
                    errorStateBuilder: (context, error) => SizedBox(
                      width: qrSize,
                      height: qrSize,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: TsdtechColors.error,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Não foi possível\ngerar o QR Code',
                              style: TsdtechTextStyles.bodySmall.copyWith(
                                color: TsdtechColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ExpiredQrOverlay extends StatelessWidget {
  const ExpiredQrOverlay({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_off_outlined,
              color: TsdtechColors.textDisabled,
              size: 48,
            ),
            SizedBox(height: 12),
            Text(
              'QR Code expirado',
              style: TextStyle(fontSize: 14, color: TsdtechColors.textDisabled),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
