import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/provider/get_interview_details_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interviews_provider.dart';
import 'package:manage_applications/repository/interview_repository.dart';
import 'package:manage_applications/repository/interview_timeline_repository.dart';

class InterviewTimelinesNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<InterviewTimeline>, int?> {
  @override
  FutureOr<List<InterviewTimeline>> build(int? arg) async {
    if (arg == null) return [];

    final details = await ref.watch(getInterviewDetailsProvider(arg).future);
    return details.timeline;
  }

  Future<OperationResult> addTimeline(InterviewTimeline timeline) async {
    state = const AsyncLoading();

    try {
      if (timeline.interviewId == null) {
        throw MissingInformationError(error: 'ID_Colloquio mancante');
      }

      final interview = _ensureInterviewExists(timeline.interviewId!);

      final result = await _repository.addInterviewTimeline(timeline);

      await _updateInterviewStatus(interview.status, timeline);
      _handlePostponed(
        result.eventType.isPostponed,
        interview.id!,
        result.newDateTime,
      );

      ref
          .read(interviewFormProvider(arg).notifier)
          .updateStatus(result.eventType);

      state = AsyncData([..._currentValue, result]);

      return Success(data: true, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return mapToFailure(e, stackTrace);
    }
  }

  InterviewUi _ensureInterviewExists(int interviewId) {
    final interviews = ref.read(interviewsProvider).value;

    if (interviews == null) {
      throw MissingInformationError(error: 'Lista colloqui vuota');
    }

    return interviews.firstWhere(
      (i) => i.id == interviewId,
      orElse:
          () => throw MissingInformationError(error: 'Colloquio non trovato'),
    );
  }

  Future<void> _updateInterviewStatus(
    InterviewStatus currentStatus,
    InterviewTimeline timeline,
  ) async {
    if (currentStatus != timeline.eventType) {
      await _interviewRepository.updateInterviewStatus(
        timeline.interviewId!,
        timeline.eventType.name,
      );

      _interviewsUiNotifier.updateInterviewStatus(
        timeline.eventType,
        timeline.interviewId!,
      );
    }
  }

  void _handlePostponed(
    bool isPostponed,
    int interviewId,
    DateTime? rescheduleDateTime,
  ) {
    if (isPostponed) {
      _interviewsUiNotifier.rescheduleDateTime(
        id: interviewId,
        rescheduleDateTime: rescheduleDateTime!,
      );
    }
  }

  InterviewsNotifier get _interviewsUiNotifier =>
      ref.read(interviewsProvider.notifier);
  InterviewTimelineRepository get _repository =>
      ref.read(interviewTimelineRepository);
  InterviewRepository get _interviewRepository => ref.read(interviewRepository);

  List<InterviewTimeline> get _currentValue => state.value ?? [];
}

final interviewTimelinesProvider = AsyncNotifierProvider.autoDispose
    .family<InterviewTimelinesNotifier, List<InterviewTimeline>, int?>(
      InterviewTimelinesNotifier.new,
    );
