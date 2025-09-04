enum FollowUpEvent { send, update, delete }

extension FollowUpEventX on FollowUpEvent {
  String get displayName {
    switch (this) {
      case FollowUpEvent.send:
        return 'Inviato';
      case FollowUpEvent.update:
        return 'Aggiornato';
      case FollowUpEvent.delete:
        return 'Eliminato';
    }
  }
}

FollowUpEvent getFollowUpEventFromString(String value) {
  switch (value) {
    case 'send':
      return FollowUpEvent.send;
    case 'update':
      return FollowUpEvent.update;
    case 'delete':
      return FollowUpEvent.delete;
    default:
      return FollowUpEvent.send;
  }
}
