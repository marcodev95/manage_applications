enum InterviewTimelineEvent { done, postponed, cancelled }

extension InterviewTimelineEventX on InterviewTimelineEvent {
  String get displayName {
    switch (this) {
      case InterviewTimelineEvent.done:
        return 'Svolto';
      case InterviewTimelineEvent.postponed:
        return 'Rinviato';
      case InterviewTimelineEvent.cancelled:
        return 'Annullato';
    }
  }

 /*  Icon get timelineIcon {
    switch (this) {
      case InterviewTimelineEvent.done:
        return Icon(Icons.check, color: Colors.green,);
      case InterviewTimelineEvent.postponed:
        return Icon(Icons.event_busy, color: Colors.amber,);
      case InterviewTimelineEvent.cancelled:
        return Icon(Icons.close, color: Colors.red);
    }
  } */

  bool get isPostponed {
    return this == InterviewTimelineEvent.postponed;
  }
}

InterviewTimelineEvent getInterviewTimelineFromString(String value) {
  switch (value) {
    case 'Svolto':
      return InterviewTimelineEvent.done;
    case 'Rinviato':
      return InterviewTimelineEvent.postponed;
    case 'Annullato':
      return InterviewTimelineEvent.cancelled;
    default:
      return InterviewTimelineEvent.done;
  }
}
