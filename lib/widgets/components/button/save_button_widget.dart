import 'package:flutter/material.dart';

class SaveButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const SaveButtonWidget({
    super.key,
    required this.onPressed,
    this.label = 'Salva',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.green,
      ),
      child: Text(label, style: TextStyle(fontSize: 18.0),),
    );
  }
}
