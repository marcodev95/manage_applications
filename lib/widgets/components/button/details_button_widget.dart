import 'package:flutter/material.dart';

class DetailsButtonWidget extends StatelessWidget {
  const DetailsButtonWidget({
    super.key,
    required this.onPressed,
    this.label = 'Dettagli',
    this.iconColor = Colors.amber,
    this.textColor = Colors.amber,
    this.borderColor = Colors.amber,
  });

  final VoidCallback onPressed;
  final String label;
  final Color iconColor;
  final Color textColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(Icons.info_outline, color: iconColor),
      label: Text(label, style: TextStyle(color: textColor)),
      style: OutlinedButton.styleFrom(side: BorderSide(color: borderColor)),
      onPressed: onPressed,
    );
  }
}
