import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Colors.blue,
    this.fontSize = 16.0,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.shape,
    this.isEnable = true,
  });

  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final double fontSize;
  final Color textColor;
  final EdgeInsets padding;
  final OutlinedBorder? shape;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(
          isEnable ? backgroundColor : backgroundColor.withAlpha(153),
        ),
        padding: WidgetStatePropertyAll<EdgeInsets>(padding),
        shape: WidgetStatePropertyAll<OutlinedBorder?>(shape),
        mouseCursor: WidgetStatePropertyAll<MouseCursor?>(
          isEnable ? null : SystemMouseCursors.basic,
        ),
        overlayColor: WidgetStatePropertyAll<Color?>(
          isEnable ? null : Colors.transparent,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: fontSize, color: textColor),
      ),
    );
  }
}

/* Per shape =>  this.shape = const StadiumBorder(
      side: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ), */
