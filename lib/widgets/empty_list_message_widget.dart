import 'package:flutter/material.dart';

class EmptyListMessageWidget extends StatelessWidget {
  const EmptyListMessageWidget(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          message,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            fontWeight: FontWeight.w400, 
            fontStyle: FontStyle.italic, 
          ),
        ),
      );
  }
}