import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interviews_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/get_interview_details_provider.dart';
import 'package:manage_applications/repository/interview_repository.dart';

//https://stackoverflow.com/questions/76934116/usage-of-ref-read-and-ref-watch-inside-onpressed-function-in-flutter

class InterviewFormController
    extends AutoDisposeFamilyAsyncNotifier<Interview, int?> {
  @override
  FutureOr<Interview> build(int? arg) async {
    if (arg == null) return Interview.defaultValue();

    final details = await ref.watch(getInterviewDetailsProvider(arg).future);
    return details.interview;
  }

  Future<OperationResult> submit(Interview interview) async {
    final service = ref.read(interviewServiceProvider);

    state = const AsyncLoading();

    try {
      final result = await service.saveInterview(interview);

      state = AsyncData(result);

      return Success<Interview>(
        data: result,
        message: SuccessMessage.saveMessage,
      );
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return mapToFailure(e, stackTrace);
    }
  }
}

final interviewFormController = AsyncNotifierProvider.autoDispose
    .family<InterviewFormController, Interview, int?>(
      InterviewFormController.new,
    );

class InterviewService {
  final InterviewRepository repository;
  final InterviewsNotifier notifier;

  InterviewService({required this.repository, required this.notifier});

  Future<Interview> saveInterview(Interview interview) async {
    if (interview.id == null) {
      final result = await repository.addInterview(interview);
      notifier.addInterview(_toUi(result));

      return result;
    } else {
      await repository.updateInterview(interview);
      notifier.updateInterview(_toUi(interview));

      return interview;
    }
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
}

final interviewServiceProvider = Provider((ref) {
  return InterviewService(
    repository: ref.read(interviewRepository),
    notifier: ref.read(interviewsProvider.notifier),
  );
});