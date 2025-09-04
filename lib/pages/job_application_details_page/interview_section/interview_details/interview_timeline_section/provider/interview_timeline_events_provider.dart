import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/timeline/timeline_event/interview_timeline_event.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form/interview_form_field_barrel.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/provider/get_interview_details_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interviews_provider.dart';
import 'package:manage_applications/repository/interview_repository.dart';
import 'package:manage_applications/repository/interview_timeline_repository.dart';

class InterviewEventNotifier
    extends FamilyAsyncNotifier<List<InterviewTimelineEvent>, int?> {
  @override
  FutureOr<List<InterviewTimelineEvent>> build(int? arg) async {
    if (arg == null) return [];

    final details = await ref.watch(getInterviewDetailsProvider(arg).future);
    return details.timeline.whereType<InterviewTimelineEvent>().toList();
  }

  Future<OperationResult> addEvent(InterviewTimelineEvent ie) async {
    state = const AsyncLoading();

    try {
      if (ie.interviewId == null) {
        throw MissingInformationError(error: 'ID_Colloquio mancante');
      }

      final interview = _ensureInterviewExists(ie.interviewId!);

      final result = await _repository.addInterviewTimeline(ie);

      await _updateInterviewStatus(interview.status, ie);
      _handlePostponed(ie.event.isPostponed, interview.id!, result.newDateTime);

      ref.read(interviewFormProvider(arg).notifier).updateStatus(ie.event);

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
    InterviewTimelineEvent ie,
  ) async {
    if (currentStatus != ie.event) {
      await _interviewRepository.updateInterviewStatus(
        ie.interviewId!,
        ie.event.name,
      );

      _interviewsUiNotifier.updateInterviewStatus(ie.event, ie.interviewId!);
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

  List<InterviewTimelineEvent> get _currentValue => state.value ?? [];
}

final interviewEventsProvider = AsyncNotifierProvider.family<
  InterviewEventNotifier,
  List<InterviewTimelineEvent>,
  int?
>(InterviewEventNotifier.new);
