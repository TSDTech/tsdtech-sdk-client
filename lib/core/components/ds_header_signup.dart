import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DsHeaderSignup extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const DsHeaderSignup({Key? key, this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, top: 24),
      alignment: Alignment.topLeft,
      child: IconButton(
        icon:
            const Icon(LucideIcons.chevronLeft, size: 24, color: Colors.black),
        onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
      ),
    );
  }
}
