import 'package:flutter/material.dart';

class OpenLinkButtonWidget extends StatelessWidget {
  const OpenLinkButtonWidget({
    super.key,
    required this.onPressed,
    this.label = 'Apri link',
    this.iconColor = Colors.blue,
    this.textColor = Colors.blue,
    this.borderColor = Colors.blue,
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
