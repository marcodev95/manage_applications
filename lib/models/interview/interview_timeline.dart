import 'package:equatable/equatable.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_monitoring_section/interview_timeline_utility.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewTimeline extends Equatable {
  final int? id;
  final InterviewTimelineEvent eventType;
  final String eventDateTime;
  final String? originalDateTime;
  final String? newDateTime;
  final String reason;
  final String requester;
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
      reason: reason,
      requester: requester,
      note: note,
      interviewId: interviewId,
    );
  }

  InterviewTimeline.fromJson(Map<String, dynamic> json)
    : id = json[InterviewTimelineTable.id],
      
      eventDateTime = json[InterviewTimelineTable.eventDateTime],
      eventType = getInterviewTimelineFromString(
        json[InterviewTimelineTable.eventType],
      ),

      originalDateTime = json[InterviewTimelineTable.originalDateTime],
      newDateTime = json[InterviewTimelineTable.newDateTime],

      reason = json[InterviewTimelineTable.reason],
      requester = json[InterviewTimelineTable.requester],
      note = json[InterviewTimelineTable.note],
      interviewId = json[InterviewTimelineTable.interviewId];

  Map<String, dynamic> toJson() => {
    InterviewTimelineTable.eventType: eventType.name,
    InterviewTimelineTable.originalDateTime: originalDateTime,
    InterviewTimelineTable.newDateTime: newDateTime,
    InterviewTimelineTable.eventDateTimeDB: convertToIsoDateTime(eventDateTime),
    InterviewTimelineTable.eventDateTime: eventDateTime,
    InterviewTimelineTable.reason: reason,
    InterviewTimelineTable.requester: requester,
    InterviewTimelineTable.note: note,
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

  //X Rinvio
  static final String originalDateTime = 'original_date_time';
  static final String newDateTime = 'new_date_time';
  static final String eventDateTimeDB = 'new_date_time_db';

  static final String reason = 'reason';
  static final String requester = 'requester';

  //FK
  static final String interviewId = 'interview_id';
}
