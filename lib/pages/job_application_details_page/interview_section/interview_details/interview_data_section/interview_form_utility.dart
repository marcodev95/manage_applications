import 'package:flutter/material.dart';

enum InterviewTypes { conoscitivo, tecnico, finale }

extension InterviewTypesExtension on InterviewTypes {
  String get displayName {
    switch (this) {
      case InterviewTypes.conoscitivo:
        return 'Conoscitivo';
      case InterviewTypes.tecnico:
        return 'Tecnico';
      case InterviewTypes.finale:
        return 'Finale';
    }
  }

  IconData get interviewTypeIcon {
    switch (this) {
      case InterviewTypes.conoscitivo:
        return Icons.chat_bubble_outline;
      case InterviewTypes.tecnico:
        return Icons.code;
      case InterviewTypes.finale:
        return Icons.flag;
    }
  }
}

InterviewTypes getInterviewTypeFromString(String value) {
  switch (value) {
    case 'Conoscitivo':
      return InterviewTypes.conoscitivo;
    case 'Tecnico':
      return InterviewTypes.tecnico;
    case 'Finale':
      return InterviewTypes.finale;
    default:
      return InterviewTypes.conoscitivo;
  }
}

enum InterviewsFormat { online, presenza, altro }

extension InterviewsFormatExtension on InterviewsFormat {
  String get displayName {
    switch (this) {
      case InterviewsFormat.online:
        return 'Online';
      case InterviewsFormat.presenza:
        return 'Indirizzo azienda';
      case InterviewsFormat.altro:
        return 'Altro';
    }
  }

  IconData get iconInterview {
    switch (this) {
      case InterviewsFormat.online:
        return Icons.videocam;
      case InterviewsFormat.presenza:
        return Icons.people;
      case InterviewsFormat.altro:
        return Icons.place;
    }
  }
}

InterviewsFormat getInterviewFormatFromString(String value) {
  switch (value) {
    case 'Online':
      return InterviewsFormat.online;
    case 'Indirizzo azienda':
      return InterviewsFormat.presenza;
    case 'Altro':
      return InterviewsFormat.altro;
    default:
      return InterviewsFormat.online;
  }
}

enum InterviewStatus { toDo, completed, cancelled, postponed }

extension InterviewStatusX on InterviewStatus {
  String get displayName {
    switch (this) {
      case InterviewStatus.toDo:
        return 'Da fare';
      case InterviewStatus.completed:
        return 'Completato';
      case InterviewStatus.postponed:
        return 'Rinviato';
      case InterviewStatus.cancelled:
        return 'Annullato';
    }
  }

  Color get iconColor {
    switch (this) {
      case InterviewStatus.toDo:
        return Colors.grey;
      case InterviewStatus.completed:
        return Colors.green;
      case InterviewStatus.postponed:
        return Colors.amber;
      case InterviewStatus.cancelled:
        return Colors.red;
    }
  }
}

InterviewStatus getInterviewStatusFromString(String value) {
  switch (value) {
    case 'Da fare':
      return InterviewStatus.toDo;
    case 'Completato':
      return InterviewStatus.completed;
    case 'Rinviato':
      return InterviewStatus.postponed;
    case 'Annullato':
      return InterviewStatus.cancelled;
    default:
      return InterviewStatus.toDo;
  }
}
