import 'package:flutter/material.dart';

class StatusChipWidget extends StatelessWidget {
  const StatusChipWidget({
    super.key,
    required this.label,
    required this.chipColor,
  });

  final String label;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label), backgroundColor: chipColor);
  }
}
