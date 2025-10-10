import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    super.key,
    this.height,
    this.thickness = 1,
    this.indent,
    this.endIndent,
    this.color = Colors.grey,
  });

  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: thickness,
      height: height,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
