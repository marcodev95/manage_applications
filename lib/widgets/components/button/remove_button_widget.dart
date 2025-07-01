import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';

class RemoveButtonWidget extends StatelessWidget {
  const RemoveButtonWidget({
    super.key,
    required this.onPressed,
    this.label = 'Elimina',
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(Icons.delete_outline, color: Colors.redAccent),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: AppStyle.tableTextFontSize,
        ),
      ),
      style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.redAccent)),
      onPressed: onPressed,
    );
  }
}
