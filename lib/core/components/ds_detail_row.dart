import 'package:flutter/material.dart';

Widget buildDetailRow(String label, String value) {
  return Row(
    children: [
      Expanded(
        child: Text(
          label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
              fontFamily: 'Open Sans',
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Open Sans',
          ),
        ),
      ],
    );
  }