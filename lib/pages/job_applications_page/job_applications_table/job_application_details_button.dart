import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/job_application_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class JobApplicationDetailsButton extends ConsumerWidget {
  const JobApplicationDetailsButton({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        ref.read(jobApplicationId.notifier).state = id;
        navigatorPush(context, const JobApplicationDetailsPage());
      },
      icon: const Icon(Icons.edit, color: Colors.amber),
    );
  }
}
