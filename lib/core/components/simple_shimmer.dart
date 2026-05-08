import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SimpleShimmer extends StatelessWidget {
  final int count;
  final double height;
  const SimpleShimmer({Key? key, this.count = 6, this.height = 80}) : super(key: key);

  Widget _shimmerItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 96,
            height: height,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: double.infinity, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 12, width: 150, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 12, width: 100, color: Colors.white),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(count, (_) => _shimmerItem(context)),
      ),
    );
  }
}
