import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interviews_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/provider/get_interview_details_provider.dart';
import 'package:manage_applications/repository/interview_repository.dart';

class InterviewFormNotifier
    extends AutoDisposeFamilyAsyncNotifier<Interview, int?> {
  @override
  FutureOr<Interview> build(int? arg) async {
    if (arg == null) return Interview.defaultValue();

    final details = await ref.watch(getInterviewDetailsProvider(arg).future);
    return details.interview;
  }

  Future<OperationResult> updateInterview(Interview interview) async {
    state = AsyncLoading();

    try {
      await _repository.updateInterview(interview);
      _notifier.updateInterview(_toUi(interview));

      state = AsyncData(interview);

      return Success(data: true, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> createInterview(Interview interview) async {
    state = AsyncLoading();

    try {
      final lastInterview = await _repository.addInterview(interview);
      _notifier.addInterview(_toUi(lastInterview));

      state = AsyncData(lastInterview);

      return Success(data: true, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<void> updateStatus(InterviewStatus newStatus) async {
    final current = state.value;
    if (current == null) return;

    final updated = current.copyWith(status: newStatus);

    state = AsyncValue.data(updated);
  }

  InterviewUi _toUi(Interview interview) {
    return InterviewUi(
      id: interview.id,
      date: interview.date,
      time: interview.time,
      type: interview.type,
      status: interview.status,
      interviewFormat: interview.interviewFormat,
      answerTime: interview.answerTime,
      followUpDate: interview.followUpDate,
      interviewPlace: interview.interviewPlace,
    );
  }

  InterviewRepository get _repository => ref.read(interviewRepository);
  InterviewsNotifier get _notifier => ref.read(interviewsProvider.notifier);
}

final interviewFormProvider = AsyncNotifierProvider.autoDispose
    .family<InterviewFormNotifier, Interview, int?>(InterviewFormNotifier.new);
