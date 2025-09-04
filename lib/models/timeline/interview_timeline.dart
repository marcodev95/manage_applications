import 'package:manage_applications/models/timeline/timeline_event/follow_up_timeline_event.dart';
import 'package:manage_applications/models/timeline/timeline_event/interview_timeline_event.dart';
import 'package:manage_applications/models/timeline/interview_timeline_event_type.dart';

abstract class InterviewTimeline {
  final DateTime eventDateTime;

  const InterviewTimeline(this.eventDateTime);

  static InterviewTimeline fromJson(Map<String, dynamic> json) {
    switch (json[InterviewTimelineTable.eventType]) {
      case InterviewTimelineEventType.interviewEvent:
        return InterviewTimelineEvent.fromJson(json);
      case InterviewTimelineEventType.followUpEvent:
        return FollowUpTimelineEvent.fromJson(json);
      default:
        throw Exception('Evento Timeline sconosciuto');
    }
  }
}

class InterviewTimelineTable {
  static final String tableName = 'interview_reschedules';

  static final String id = '_id_interview_reschedule';

  static final String event = 'event';
  static final String eventType = 'event_type';
  static final String eventDateTime = 'event_date_time';

  static final String note = 'note';

  static final String originalDateTime = 'original_date_time';
  static final String newDateTime = 'new_date_time';

  static final String reason = 'reason';
  static final String requester = 'requester';

  static final String relocatedAddress = 'relocated_address';

  static final String followUpSentAt = 'follow_up_sent_at';
  static final String followUpSentTo = 'follow_up_sent_to';

  static final String interviewId = 'interview_id';
}
