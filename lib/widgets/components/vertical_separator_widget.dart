import 'package:flutter/material.dart';

class VerticalSeparatorWidget extends StatelessWidget {
  const VerticalSeparatorWidget({
    super.key,
    this.height = 20,
    this.thickness = 1,
    this.color = Colors.grey,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final double height;
  final double thickness;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: 1,
        height: height,
        child: DecoratedBox(decoration: BoxDecoration(color: color)),
      ),
    );
  }
}
