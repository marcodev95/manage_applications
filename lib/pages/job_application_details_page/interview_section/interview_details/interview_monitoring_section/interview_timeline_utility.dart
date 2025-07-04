enum InterviewTimelineEvent {
  done,
  postponed,
  cancelled,
  relocated,
  reminderSent,
}

extension InterviewTimelineEventX on InterviewTimelineEvent {
  String get displayName {
    switch (this) {
      case InterviewTimelineEvent.done:
        return 'Svolto';
      case InterviewTimelineEvent.postponed:
        return 'Rinviato';
      case InterviewTimelineEvent.cancelled:
        return 'Annullato';
      case InterviewTimelineEvent.relocated:
        return 'Luogo modificato';
      case InterviewTimelineEvent.reminderSent:
        return 'Inviato follow-up';
    }
  }

  bool get isPostponed {
    return this == InterviewTimelineEvent.postponed;
  }
}

InterviewTimelineEvent getInterviewTimelineFromString(String value) {
  switch (value) {
    case 'done':
      return InterviewTimelineEvent.done;
    case 'postponed':
      return InterviewTimelineEvent.postponed;
    case 'cancelled':
      return InterviewTimelineEvent.cancelled;
    case 'relocated':
      return InterviewTimelineEvent.relocated;
    case 'reminderSent':
      return InterviewTimelineEvent.reminderSent;
    default:
      return InterviewTimelineEvent.done;
  }
}
