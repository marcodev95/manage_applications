import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/timeline/interview_timeline.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_follow_ups_section/interview_follow_up_utility.dart';

class FollowUpTimelineEvent extends InterviewTimeline
    implements EquatableMixin {
  final int? id;
  final FollowUpEvent event;
  final String type;
  final String followUpSentTo;
  final int? interviewId;

  const FollowUpTimelineEvent({
    this.id,
    required this.event,
    required this.type,
    required DateTime eventDateTime,
    required this.followUpSentTo,
    this.interviewId,
  }) : super(eventDateTime);

  FollowUpTimelineEvent.fromJson(Map<String, dynamic> json)
    : id = json[InterviewTimelineTable.id],
      event = getFollowUpEventFromString(json[InterviewTimelineTable.event]),
      type = json[InterviewTimelineTable.eventType],
      followUpSentTo = json[InterviewTimelineTable.followUpSentTo],
      interviewId = json[InterviewTimelineTable.interviewId],
      super(DateTime.parse(json[InterviewTimelineTable.eventDateTime]));

  Map<String, dynamic> toJson() => {
    InterviewTimelineTable.event: event.name,
    InterviewTimelineTable.eventType: type,
    InterviewTimelineTable.eventDateTime: eventDateTime.toIso8601String(),
    InterviewTimelineTable.followUpSentTo: followUpSentTo,
    InterviewTimelineTable.interviewId: interviewId,
  };

  FollowUpTimelineEvent copyWith({int? id}) {
    return FollowUpTimelineEvent(
      id: id ?? this.id,
      type: type,
      event: event,
      eventDateTime: eventDateTime,
      followUpSentTo: followUpSentTo,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return ''' 
      ID => $id 
      Event => $event
      Date => $eventDateTime
      Sent => $followUpSentTo
    ''';
  }

  @override
  bool? get stringify => throw UnimplementedError();
}
