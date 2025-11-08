import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';

class ResponsiveLayoutWidget extends StatelessWidget {
  const ResponsiveLayoutWidget({
    super.key,
    required this.desktop,
    required this.compact,
  });

  final Widget Function(BuildContext, BoxConstraints) desktop;
  final Widget Function(BuildContext, BoxConstraints) compact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppStyle.compactBreakpoint) {
          return compact(context, constraints);
        }

        return desktop(context, constraints);
      },
    );
  }
}
