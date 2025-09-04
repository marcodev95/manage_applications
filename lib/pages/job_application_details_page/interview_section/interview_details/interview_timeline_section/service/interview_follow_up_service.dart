import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/timeline/interview_timeline_event_type.dart';
import 'package:manage_applications/models/timeline/timeline_event/follow_up_timeline_event.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_follow_ups_section/interview_follow_up_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_follow_ups_section/interview_follow_ups_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/provider/interview_timeline_follow_up_events_provider.dart';

class InterviewFollowupService {
  Ref<Object?> ref;

  InterviewFollowupService(this.ref);

  Future<OperationResult> createFollowUpWithEvent({
    int? routeArgID,
    required InterviewFollowUp followUp,
  }) async {
    try {
      final followUpResult = await ref
          .read(interviewFollowUpsProvider(routeArgID).notifier)
          .createOrUpdate(followUp);

      if (followUpResult.isFailure) return followUpResult;

      final fte = FollowUpTimelineEvent(
        event: FollowUpEvent.send,
        type: InterviewTimelineEventType.followUpEvent,
        eventDateTime: followUp.followUpDate,
        followUpSentTo: 'HR',
        interviewId: followUp.interviewId,
      );

      final event = await ref
          .read(followUpEventsProvider(routeArgID).notifier)
          .addEvent(fte);

      if (event.isFailure) return event;

      return Success(data: true, message: followUpResult.message);
    } catch (e, stackTrace) {
      return mapToFailure(e, stackTrace);
    }
  }
}

final followUpService = Provider((ref) => InterviewFollowupService(ref));
