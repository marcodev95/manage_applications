import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/repository/interview_repository.dart';

class InterviewsNotifier extends AutoDisposeAsyncNotifier<List<InterviewUi>> {
  @override
  FutureOr<List<InterviewUi>> build() async {
    final interviews = await ref.watch(
      fetchJobApplicationDetailsProvider.future,
    );

    return interviews.interviews;
  }

  void addInterview(InterviewUi interview) {
    state = state.whenData((value) => [...value, interview]);
  }

  void updateInterview(InterviewUi interview) {
    state = state.whenData((value) {
      return [
        for (final el in value)
          if (el.id == interview.id)
            el.copyWith(
              status: interview.status,
              answerTime: interview.answerTime,
              interviewFormat: interview.interviewFormat,
              interviewPlace: interview.interviewPlace,
              type: interview.type,
            )
          else
            el,
      ];
    });
  }

  Future<OperationResult> deleteInterview(int id) async {
    final repository = ref.read(interviewRepository);

    final currentInterviews = state.value ?? [];

    state = const AsyncLoading();

    try {
      await repository.deleteInterview(id);

      currentInterviews.removeWhere((element) => element.id == id);

      state = AsyncData(currentInterviews);

      return Success(data: true, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  void rescheduleDateTime({
    required int id,
    required DateTime rescheduleDateTime,
  }) {
    state = state.whenData((value) {
      final newList = [
        for (final el in value)
          if (el.id == id)
            el.copyWith(rescheduleDateTime: rescheduleDateTime)
          else
            el,
      ];
      return newList;
    });
  }
}

final interviewsProvider =
    AutoDisposeAsyncNotifierProvider<InterviewsNotifier, List<InterviewUi>>(
      InterviewsNotifier.new,
    );
