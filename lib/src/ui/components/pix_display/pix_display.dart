import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';

import 'pix_display_defaults.dart';
import 'pix_display_copy_field.dart';
import 'pix_display_countdown.dart';
import 'pix_display_instructions.dart';
import 'pix_display_qr_section.dart';

class PixDisplay extends StatefulWidget {
  const PixDisplay({
    super.key,
    required this.pixData,
    this.expiresAt,
    this.onExpired,
    this.onCopied,
    this.instructions,
    this.qrSize = 220.0,
  });

  final PixData pixData;
  final DateTime? expiresAt;
  final VoidCallback? onExpired;
  final VoidCallback? onCopied;
  final List<String>? instructions;
  final double qrSize;

  @override
  State<PixDisplay> createState() => _PixDisplayState();
}

class _PixDisplayState extends State<PixDisplay> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _expired = false;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void didUpdateWidget(PixDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expiresAt != widget.expiresAt) {
      _timer?.cancel();
      _initTimer();
    }
  }

  void _initTimer() {
    final expiresAt = widget.expiresAt;
    if (expiresAt == null) return;

    _remaining = expiresAt.difference(DateTime.now());
    if (_remaining.isNegative || _remaining == Duration.zero) {
      _expired = true;
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = expiresAt.difference(DateTime.now());
      if (remaining.isNegative || remaining == Duration.zero) {
        setState(() {
          _remaining = Duration.zero;
          _expired = true;
        });
        _timer?.cancel();
        widget.onExpired?.call();
      } else {
        setState(() => _remaining = remaining);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.pixData.copyPasteCode));
    setState(() => _copied = true);
    widget.onCopied?.call();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Color get _timerColor {
    if (_expired) return TsdtechColors.error;
    if (_remaining.inMinutes < 5) return TsdtechColors.warning;
    return TsdtechColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixQrSection(
          pixData: widget.pixData,
          qrSize: widget.qrSize,
          expired: _expired,
        ),
        const SizedBox(height: 20),
        if (widget.expiresAt != null) ...[
          PixCountdown(
            expired: _expired,
            timerColor: _timerColor,
            formattedRemaining: formatPixDuration(_remaining),
          ),
          const SizedBox(height: 20),
        ],
        PixCopyField(
          copyPasteCode: widget.pixData.copyPasteCode,
          copied: _copied,
          expired: _expired,
          onCopy: _copyCode,
        ),
        const SizedBox(height: 24),
        PixInstructions(steps: widget.instructions ?? defaultPixInstructions),
      ],
    );
  }
}
