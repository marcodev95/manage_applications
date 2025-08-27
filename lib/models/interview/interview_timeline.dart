import 'package:equatable/equatable.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/interview_timeline_utility.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewTimeline extends Equatable {
  final int? id;
  final InterviewStatus eventType;
  final DateTime eventDateTime;
  final DateTime? originalDateTime;
  final DateTime? newDateTime;
  final String reason;
  final String requester;
  final DateTime? followUpSentAt;
  final String? followUpSentTo;
  final String? relocatedAddress;
  final String? note;
  final int? interviewId;

  const InterviewTimeline({
    this.id,
    required this.eventType,
    required this.eventDateTime,
    required this.reason,
    required this.requester,
    this.originalDateTime,
    this.newDateTime,
    this.followUpSentAt,
    this.followUpSentTo,
    this.relocatedAddress,
    this.note,
    this.interviewId,
  });

  InterviewTimeline copyWith({int? id}) {
    return InterviewTimeline(
      id: id ?? this.id,
      eventType: eventType,
      originalDateTime: originalDateTime,
      newDateTime: newDateTime,
      eventDateTime: eventDateTime,
      relocatedAddress: relocatedAddress,
      reason: reason,
      followUpSentAt: followUpSentAt,
      followUpSentTo: followUpSentTo,
      requester: requester,
      note: note,
      interviewId: interviewId,
    );
  }

  InterviewTimeline.fromJson(Map<String, dynamic> json)
    : id = json[InterviewTimelineTable.id],

      eventDateTime = DateTime.parse(json[InterviewTimelineTable.eventDateTime]),
      eventType = getInterviewStatusFromString(
        json[InterviewTimelineTable.eventType],
      ),

      originalDateTime = parseDateTimeOrNull(json[InterviewTimelineTable.originalDateTime]),
      newDateTime = parseDateTimeOrNull(json[InterviewTimelineTable.newDateTime]),

      followUpSentAt = parseDateTimeOrNull(json[InterviewTimelineTable.followUpSentAt]),
      followUpSentTo = json[InterviewTimelineTable.followUpSentTo],

      relocatedAddress = json[InterviewTimelineTable.relocatedAddress],

      reason = json[InterviewTimelineTable.reason],
      requester = json[InterviewTimelineTable.requester],
      note = json[InterviewTimelineTable.note],
      interviewId = json[InterviewTimelineTable.interviewId];

  Map<String, dynamic> toJson() => {
    InterviewTimelineTable.eventType: eventType.name,
    InterviewTimelineTable.originalDateTime: convertToIsoString(originalDateTime),
    InterviewTimelineTable.newDateTime: convertToIsoString(newDateTime),
    InterviewTimelineTable.eventDateTime: eventDateTime.toIso8601String(),
    InterviewTimelineTable.followUpSentAt: convertToIsoString(followUpSentAt),
    InterviewTimelineTable.followUpSentTo: followUpSentTo,
    InterviewTimelineTable.reason: reason,
    InterviewTimelineTable.requester: requester,
    InterviewTimelineTable.note: note,
    InterviewTimelineTable.relocatedAddress: relocatedAddress,
    InterviewTimelineTable.interviewId: interviewId,
  };

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return '''
      ID => $id
      Event => $eventType
      Original_Date_Time => $originalDateTime
      New_Date_Time => $newDateTime
      Requester => $requester
      Reason => $reason
      Note => $note
      InterviewId => $interviewId
    ''';
  }
}

class InterviewTimelineTable {
  static final String tableName = 'interview_reschedules';

  static final String id = '_id_interview_reschedule';

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
