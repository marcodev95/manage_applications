import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';

class JobApplicationRemoveButtonWidget extends ConsumerWidget {
  const JobApplicationRemoveButtonWidget(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuItem<String>(
      value: "delete",
      child: const Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.delete, color: Colors.red),
          Text('Elimina candidatura'),
        ],
      ),
      onTap: () async {
        final delete = await ref
            .read(paginatorApplicationsUIProvider.notifier)
            .deleteJobApplication(id);

        if (!context.mounted) return;

        delete.handleResult(context: context, ref: ref);
      },
    );

    /* IconButton(
      onPressed: () async {
        final delete = await ref
            .read(paginatorApplicationsUIProvider.notifier)
            .deleteJobApplication(id);

        if (!context.mounted) return;

        delete.handleResult(context: context, ref: ref);
      },
      icon: const Icon(Icons.delete, color: Colors.red),
    ); */
  }
}
