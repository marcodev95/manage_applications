import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_list_widget.dart';
import 'package:manage_applications/widgets/components/errors_widget/icon_with_badge_widget.dart';

class ErrorsPanelButtonWidget   extends ConsumerWidget {
  const ErrorsPanelButtonWidget ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ElevatedButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder:
                  (context) => const AlertDialog(
                    title: Text('Lista degli errori'),
                    content: SizedBox(
                      width: 800.0,
                      height: 600.0,
                      child: ErrorsListWidget(),
                    ),
                  ),
            );
          },
          child: Text('Pannello degli errori'),
        ),
        IconWithBadgeWidget(icon: SizedBox.shrink()),
      ],
    );
  }
}
