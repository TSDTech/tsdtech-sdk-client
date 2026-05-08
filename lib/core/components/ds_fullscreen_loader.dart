import 'package:flutter/material.dart';
import 'ds_circular_progress_indicator.dart';

class DsFullscreenLoader extends StatelessWidget {
  final String? message;

  const DsFullscreenLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.45),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DsCircularProgressIndicator(strokeWidth: 3.5),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: const TextStyle(color: Colors.white),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
