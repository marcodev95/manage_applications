import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/get_interview_details_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_controller.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_monitoring_section/interview_timeline_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interviews_provider.dart';
import 'package:manage_applications/repository/interview_timeline_repository.dart';

class InterviewTimelineNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<InterviewTimeline>, int?> {
  @override
  FutureOr<List<InterviewTimeline>> build(int? arg) async {
    if (arg == null) return [];

    final details = await ref.watch(getInterviewDetailsProvider(arg).future);
    return details.timeline;
  }

  Future<OperationResult> addTimeline(InterviewTimeline timeline) async {
    final currentState = state.value ?? [];

    state = const AsyncLoading();

    try {
      if (_interviewId == null) {
        throw MissingInformationError(error: 'ID_Colloquio mancante');
      }

      final result = await _repository.addInterviewTimeline(timeline);

      state = AsyncData([...currentState, result]);

      if (result.eventType.isPostponed) {
        final interviewNotifer = ref.read(interviewsProvider.notifier);
        interviewNotifer.rescheduleDateTime(
          id: _interviewId!,
          rescheduleDateTime: result.newDateTime!,
        );
      }

      return Success(data: result, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return mapToFailure(e, stackTrace);
    }
  }

  InterviewTimelineRepository get _repository =>
      ref.read(interviewTimelineRepository);

  int? get _interviewId => ref.read(interviewFormController(arg)).value?.id;
}

final interviewTimelineProvider = AsyncNotifierProvider.autoDispose
    .family<InterviewTimelineNotifier, List<InterviewTimeline>, int?>(
      InterviewTimelineNotifier.new,
    );
