import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_list_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';

class ErrorsPage extends ConsumerWidget {
  const ErrorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.all(AppStyle.pad24),
      child: Column(
        children: [
          SectionTitle('Elenco degli errori'),
          Expanded(child: ErrorsListWidget()),
        ],
      ),
    );
  }
}
