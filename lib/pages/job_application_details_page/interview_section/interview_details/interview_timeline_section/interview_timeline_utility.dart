enum InterviewTimelineEvent {
  toDo,
  done,
  postponed,
  cancelled,
  relocated,
  followUpSent,
}

extension InterviewTimelineEventX on InterviewTimelineEvent {
  String get displayName {
    switch (this) {
      case InterviewTimelineEvent.toDo:
        return 'Da fare';
      case InterviewTimelineEvent.done:
        return 'Svolto';
      case InterviewTimelineEvent.postponed:
        return 'Rinviato';
      case InterviewTimelineEvent.cancelled:
        return 'Annullato';
      case InterviewTimelineEvent.relocated:
        return 'Luogo modificato';
      case InterviewTimelineEvent.followUpSent:
        return 'Inviato follow-up';
    }
  }

  bool get isPostponed {
    return this == InterviewTimelineEvent.postponed;
  }

  bool get isRelocatedPlace {
    return this == InterviewTimelineEvent.relocated;
  }
}

InterviewTimelineEvent getInterviewTimelineFromString(String value) {
  switch (value) {
    case 'toDo': 
      return InterviewTimelineEvent.toDo;
    case 'done':
      return InterviewTimelineEvent.done;
    case 'postponed':
      return InterviewTimelineEvent.postponed;
    case 'cancelled':
      return InterviewTimelineEvent.cancelled;
    case 'relocated':
      return InterviewTimelineEvent.relocated;
    case 'followUpSent':
      return InterviewTimelineEvent.followUpSent;
    default:
      return InterviewTimelineEvent.done;
  }
}
