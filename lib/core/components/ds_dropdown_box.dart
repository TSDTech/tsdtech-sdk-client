import 'package:flutter/material.dart';

class DsDropdownBox extends StatelessWidget {
  final List<Widget> children;

  const DsDropdownBox({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: child,
                ))
            .toList(),
      ),
    );
  }
}
