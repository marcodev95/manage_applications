import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/timeline/interview_timeline.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form/interview_form_field_barrel.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewTimelineEvent extends InterviewTimeline
    implements EquatableMixin {
  final int? id;
  final InterviewStatus event;
  final String eventType;
  final DateTime? originalDateTime;
  final DateTime? newDateTime;
  final String reason;
  final String requester;
  final String? note;
  final int? interviewId;

  const InterviewTimelineEvent({
    this.id,
    required this.event,
    required this.eventType,
    required DateTime eventDateTime,
    required this.reason,
    required this.requester,
    this.originalDateTime,
    this.newDateTime,
    this.note,
    this.interviewId,
  }) : super(eventDateTime);

  InterviewTimelineEvent copyWith({int? id}) {
    return InterviewTimelineEvent(
      id: id ?? this.id,
      event: event,
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

  InterviewTimelineEvent.fromJson(Map<String, dynamic> json)
    : id = json[InterviewTimelineTable.id],

      eventType = json[InterviewTimelineTable.eventType],
      event = getInterviewStatusFromString(json[InterviewTimelineTable.event]),

      originalDateTime = parseDateTimeOrNull(
        json[InterviewTimelineTable.originalDateTime],
      ),
      newDateTime = parseDateTimeOrNull(
        json[InterviewTimelineTable.newDateTime],
      ),
      reason = json[InterviewTimelineTable.reason],
      requester = json[InterviewTimelineTable.requester],
      note = json[InterviewTimelineTable.note],
      interviewId = json[InterviewTimelineTable.interviewId],
      super(DateTime.parse(json[InterviewTimelineTable.eventDateTime]));

  Map<String, dynamic> toJson() => {
    InterviewTimelineTable.event: event.name,
    InterviewTimelineTable.eventType: eventType,
    InterviewTimelineTable.originalDateTime: convertToIsoString(
      originalDateTime,
    ),
    InterviewTimelineTable.newDateTime: convertToIsoString(newDateTime),
    InterviewTimelineTable.eventDateTime: eventDateTime.toIso8601String(),
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
      Event => $event
      EventType => $eventType
      EventDateTime => $eventDateTime
      Original_Date_Time => $originalDateTime
      New_Date_Time => $newDateTime
      Requester => $requester
      Reason => $reason
      Note => $note
      InterviewId => $interviewId
    ''';
  }

  @override
  bool? get stringify => throw UnimplementedError();
}
