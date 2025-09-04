import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/interview/referents_interview.dart';
import 'package:manage_applications/models/timeline/interview_timeline.dart';
import 'package:manage_applications/models/timeline/timeline_event/interview_timeline_event.dart';

class InterviewDetails {
  final Interview interview;
  final List<SelectedReferentsForInterview> referents;
  final List<InterviewFollowUp> followUps;
  final List<InterviewTimeline> timeline;

  InterviewDetails({
    required this.interview,
    this.referents = const [],
    this.followUps = const [],
    this.timeline = const [],
  });

  InterviewDetails.fromJson(Map<String, dynamic> json)
    : interview = Interview.fromJson(json['interview']),
      followUps =
          json['follow_ups'] != null
              ? List.from(
                json['follow_ups'].map(
                  (followUp) => InterviewFollowUp.fromJson(followUp),
                ),
              )
              : [],
      referents =
          json['referents'] != null
              ? List.from(
                json['referents'].map(
                  (referent) =>
                      SelectedReferentsForInterview.fromJson(referent),
                ),
              )
              : [],
      timeline =
          json['timeline'] != null
              ? List.from(
                json['timeline'].map(
                  (reschedule) => InterviewTimeline.fromJson(reschedule),
                ),
              )
              : [];
  static InterviewDetails defaultValue() {
    return InterviewDetails(
      interview: Interview.defaultValue(),
      referents: [],
      followUps: [],
      timeline: [],
    );
  }

  InterviewDetails copyWith({
    Interview? interview,
    List<SelectedReferentsForInterview>? referents,
    List<InterviewFollowUp>? followUps,
    List<InterviewTimeline>? reschedules,
    List<InterviewTimelineEvent>? timeline,
  }) {
    return InterviewDetails(
      interview: interview ?? this.interview,
      referents: referents ?? this.referents,
      followUps: followUps ?? this.followUps,
      timeline: timeline ?? this.timeline,
    );
  }

  @override
  String toString() {
    return ''' __INTERVIEW_DETAILS__ 
      { 
        interview => $interview,
        referents => [ $referents ]
        followUps => [ $followUps ]
        reschedules => [ $timeline ]
      } ''';
  }
}
