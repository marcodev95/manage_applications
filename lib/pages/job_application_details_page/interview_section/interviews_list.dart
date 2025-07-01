import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_card.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interviews_provider.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class InterviewsList extends ConsumerWidget {
  const InterviewsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenOnErrorWithoutSnackbar(
      provider: interviewsProvider,
      context: context,
    );

    final interviewsAsync = ref.watch(interviewsProvider);

    return interviewsAsync.when(
      skipError: true,
      skipLoadingOnReload: true,
      data: (interviews) {
        return ListView.builder(
          primary: false,
          itemCount: interviews.length,
          padding: const EdgeInsets.only(right: 20),
          itemBuilder: (_, index) {
            return InterviewCard(interviews[index]);
          },
        );
      },
      error: (_, __) => DataLoadErrorScreenWidget(onPressed: () {}),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
