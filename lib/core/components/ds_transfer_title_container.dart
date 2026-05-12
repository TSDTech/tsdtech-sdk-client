import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/core/components/ds_status_bar.dart';

class DsTransferTitleContainer extends StatelessWidget {
  final List<String> statusLabels;
  final int currentStatusIndex;

  const DsTransferTitleContainer({
    super.key,
    required this.statusLabels,
    required this.currentStatusIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DsText(
          text: 'Defina os termos de venda',
          variant: DsTextVariant.title,
        ),
        const SizedBox(height: 4),
        DsText(
          text: 'Defina os termos de negociação para a venda do veículo',
          variant: DsTextVariant.base,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 16),
        DsStatusBar(
          labels: statusLabels,
          currentIndex: currentStatusIndex,
          onPressed: (index) {
            // Optional: handle status bar step tap
          },
        ),
      ],
    );
  }
}
