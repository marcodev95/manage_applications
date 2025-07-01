import 'dart:async';

import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_follow_ups_section/interview_follow_ups_controller.dart';
import 'package:manage_applications/repository/interview_follow_ups_repository.dart';
import 'package:riverpod/riverpod.dart';

class InterviewFollowUpFormController
    extends AutoDisposeFamilyAsyncNotifier<InterviewFollowUp, int> {
  @override
  FutureOr<InterviewFollowUp> build(int arg) {
    return InterviewFollowUp.defaultValue();
  }

  Future<void> createFollowUp(InterviewFollowUp followUp) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _repository.addFollowUp(followUp);

      _followUpsNotifier.createFollowUp(result);

      return result;
    });
  }

  Future<void> updateFollowUp(InterviewFollowUp followUp) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.updateFollowUp(followUp);

      _followUpsNotifier.updateFollowUp(followUp);

      return followUp;
    });
  }

  Future<void> submit(InterviewFollowUp followUp) async {
    if (followUp.interviewId == null) {
      state = AsyncError(
        MissingInformationError(
          error: 'ID del colloquio mancante',
          stackTrace: StackTrace.current,
        ),
        StackTrace.current,
      );
      return;
    }

    followUp.id == null
        ? await createFollowUp(followUp)
        : await updateFollowUp(followUp);
  }

  

  InterviewFollowUpsRepository get _repository =>
      ref.read(interviewFollowUpsRepositoryProvider);
  InterviewFollowUpsController get _followUpsNotifier =>
      ref.read(interviewFollowUpsController(arg).notifier);
}

final interviewFollowUpFormController = AsyncNotifierProvider.autoDispose
    .family<InterviewFollowUpFormController, InterviewFollowUp, int>(
      InterviewFollowUpFormController.new,
    );
