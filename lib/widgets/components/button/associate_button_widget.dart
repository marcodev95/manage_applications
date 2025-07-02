import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';

class AssociateButtonWidget extends StatelessWidget {
  const AssociateButtonWidget(
    this.onPressed, {
    super.key,
    this.color = Colors.blue,
  });

  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      label: const Text('Associa', style: TextStyle(fontSize: AppStyle.tableTextFontSize),),
      icon: Icon(Icons.person_add_alt_1, color: color),
      style: TextButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.5),
      ),
    );
  }
}
