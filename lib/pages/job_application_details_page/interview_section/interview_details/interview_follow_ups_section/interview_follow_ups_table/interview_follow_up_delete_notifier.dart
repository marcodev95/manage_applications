import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_follow_ups_section/interview_follow_ups_controller.dart';
import 'package:manage_applications/repository/interview_follow_ups_repository.dart';

class InterviewFollowUpDeleteNotifier
    extends AutoDisposeFamilyAsyncNotifier<InterviewFollowUp, int> {
  @override
  FutureOr<InterviewFollowUp> build(int arg) {
    return InterviewFollowUp.defaultValue();
  }

  Future<void> deleteFollowUp(InterviewFollowUp followUp) async {
    final repository = ref.read(interviewFollowUpsRepositoryProvider);
    final followUpsNotifier = ref.read(interviewFollowUpsController(arg).notifier);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.deleteFollowUp(followUp.id!);

      followUpsNotifier.deleteFollowUp(followUp);

      return followUp;
    });
  }
}

final interviewFollowUpDeleteProvider = AsyncNotifierProvider.autoDispose
    .family<InterviewFollowUpDeleteNotifier, InterviewFollowUp, int>(
      InterviewFollowUpDeleteNotifier.new,
    );
