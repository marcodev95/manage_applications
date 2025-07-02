import 'package:flutter/material.dart';

class AssociateButtonWidget extends StatelessWidget {
  const AssociateButtonWidget(this.onPressed, {super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      label: Text('Associa'),
      icon: Icon(Icons.person_add_alt_1, color: Colors.blue),
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
        side: BorderSide(color: Colors.blue, width: 1.5),
      ),
    );
  }
}
