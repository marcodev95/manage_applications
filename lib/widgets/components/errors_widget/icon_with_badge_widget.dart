import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_notifier.dart';

class IconWithBadgeWidget extends ConsumerWidget {
  final Widget icon;
  final double top;
  final double right;
  final Color badgeColor;

  const IconWithBadgeWidget({
    super.key,
    required this.icon,
    this.top = 0,
    this.right = -5,
    this.badgeColor = Colors.red,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorsNumber = ref.watch(countErrorsProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        if (errorsNumber > 0)
          Positioned(
            top: top,
            right: right,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$errorsNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
