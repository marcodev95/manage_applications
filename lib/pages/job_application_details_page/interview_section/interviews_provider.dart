import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
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
              placeUpdated: interview.placeUpdated,
              interviewFormat: interview.interviewFormat,
              interviewPlace: interview.interviewPlace,
              previousInterviewPlace: el.previousInterviewPlace,
              type: interview.type,
            )
          else
            el,
      ];
    });
  }

  void updateInterviewStatus(InterviewStatus status, int id) {
    state = state.whenData((value) {
      return [
        for (final el in value)
          if (el.id == id) el.copyWith(status: status) else el,
      ];
    });
  }

  Future<OperationResult> deleteInterview(int id) async {
    final currentInterviews = state.value ?? [];

    state = const AsyncLoading();

    try {
      await _repository.deleteInterview(id);

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

  void updateReschedulePlace(int id, String newPlace) {
    state = state.whenData((value) {
      return [
        for (final el in value)
          if (el.id == id)
            el.copyWith(
              placeUpdated: true,
              previousInterviewPlace: el.interviewPlace,
              interviewPlace: newPlace,
            )
          else
            el,
      ];
    });
  }

  InterviewRepository get _repository => ref.read(interviewRepository);
}

final interviewsProvider =
    AutoDisposeAsyncNotifierProvider<InterviewsNotifier, List<InterviewUi>>(
      InterviewsNotifier.new,
    );
