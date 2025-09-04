import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/timeline/timeline_event/follow_up_timeline_event.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/provider/get_interview_details_provider.dart';
import 'package:manage_applications/repository/interview_timeline_repository.dart';

class FollowUpEventNotifier
    extends FamilyAsyncNotifier<List<FollowUpTimelineEvent>, int?> {
  @override
  FutureOr<List<FollowUpTimelineEvent>> build(int? arg) async {
    if (arg == null) return [];

    final details = await ref.watch(getInterviewDetailsProvider(arg).future);
    final list = details.timeline.whereType<FollowUpTimelineEvent>().toList();

    return list;
  }

  Future<OperationResult> addEvent(FollowUpTimelineEvent fe) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      if (fe.interviewId == null) {
        throw MissingInformationError(error: 'ID_Colloquio mancante');
      }

      final result = await _repository.addFollowUpOnTimeline(fe);
      return [..._currentValue, result];
    });

    if (state.hasError) {
      return mapToFailure(state.error!, state.stackTrace!);
    } else {
      return Success(data: true, message: SuccessMessage.saveMessage);
    }
  }

  InterviewTimelineRepository get _repository =>
      ref.read(interviewTimelineRepository);

  List<FollowUpTimelineEvent> get _currentValue => state.value ?? [];
}

final followUpEventsProvider = AsyncNotifierProvider.family<
  FollowUpEventNotifier,
  List<FollowUpTimelineEvent>,
  int?
>(FollowUpEventNotifier.new);
