import 'package:flutter/material.dart';

enum InterviewTypes { conoscitivo, telefonico, tecnico, gruppo, finale }

extension InterviewTypesExtension on InterviewTypes {
  String get displayName {
    switch (this) {
      case InterviewTypes.conoscitivo:
        return 'Conoscitivo';
      case InterviewTypes.telefonico:
        return 'Telefonico';
      case InterviewTypes.tecnico:
        return 'Tecnico';
      case InterviewTypes.finale:
        return 'Finale';
      case InterviewTypes.gruppo:
        return 'Di gruppo';
    }
  }

  IconData get interviewTypeIcon {
    switch (this) {
      case InterviewTypes.conoscitivo:
        return Icons.chat_bubble_outline;
      case InterviewTypes.telefonico:
        return Icons.phone;
      case InterviewTypes.tecnico:
        return Icons.code;
      case InterviewTypes.finale:
        return Icons.flag;
      case InterviewTypes.gruppo:
        return Icons.people_alt;
    }
  }
}

InterviewTypes getInterviewTypeFromString(String value) {
  switch (value) {
    case 'conoscitivo':
      return InterviewTypes.conoscitivo;
    case 'tecnico':
      return InterviewTypes.tecnico;
    case 'finale':
      return InterviewTypes.finale;
    case 'gruppo':
      return InterviewTypes.gruppo;
    case 'telefonico':
      return InterviewTypes.telefonico;
    default:
      return InterviewTypes.conoscitivo;
  }
}

enum InterviewsFormat { online, telefono, presenza, altro }

extension InterviewsFormatExtension on InterviewsFormat {
  String get displayName {
    switch (this) {
      case InterviewsFormat.online:
        return 'Online';
      case InterviewsFormat.presenza:
        return 'Indirizzo azienda';
      case InterviewsFormat.telefono:
        return 'Telefono';
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
      case InterviewsFormat.telefono:
        return Icons.phone;
      case InterviewsFormat.altro:
        return Icons.place;
    }
  }
}

InterviewsFormat getInterviewFormatFromString(String value) {
  switch (value) {
    case 'online':
      return InterviewsFormat.online;
    case 'presenza':
      return InterviewsFormat.presenza;
    case 'telefono':
      return InterviewsFormat.telefono;
    case 'altro':
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
    case 'toDo':
      return InterviewStatus.toDo;
    case 'completed':
      return InterviewStatus.completed;
    case 'postponed':
      return InterviewStatus.postponed;
    case 'cancelled':
      return InterviewStatus.cancelled;
    default:
      return InterviewStatus.toDo;
  }
}
