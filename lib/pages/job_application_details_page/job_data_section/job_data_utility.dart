import 'package:flutter/material.dart';
import 'package:manage_applications/providers/job_application_filter.dart';

enum JobDataWorkType { ibrido, remoto, presenza }

extension JobDataWorkTypeX on JobDataWorkType {
  String get displayName {
    switch (this) {
      case JobDataWorkType.ibrido:
        return 'Ibrido';
      case JobDataWorkType.remoto:
        return 'Remoto';
      case JobDataWorkType.presenza:
        return 'Presenza';
    }
  }
}

JobDataWorkType workTypeFromString(String value) {
  switch (value) {
    case 'Ibrido':
      return JobDataWorkType.ibrido;
    case 'Remoto':
      return JobDataWorkType.remoto;
    case 'Presenza':
      return JobDataWorkType.ibrido;
    default:
      return JobDataWorkType.ibrido;
  }
}

enum ApplicationStatus { apply, interview, pendingResponse }

extension ApplicationStatusX on ApplicationStatus {
  String get displayName {
    switch(this) {
      case ApplicationStatus.apply:
        return 'Candidato';
      case ApplicationStatus.interview:
        return 'Colloquio';
      case ApplicationStatus.pendingResponse:
        return 'In attesa';
    }
  }

    Color get displayChipColor {
    switch(this) {
      
      case ApplicationStatus.apply:
        return FilterColor.apply;
      case ApplicationStatus.interview:
        return FilterColor.interview;
      case ApplicationStatus.pendingResponse:
        return FilterColor.pendingResponse;
    }
  }
}
ApplicationStatus applicationStatusFromString(String value) {
  switch (value) {
    case 'Candidato':
      return ApplicationStatus.apply;
    case 'Colloquio':
      return ApplicationStatus.interview;
    case 'In attesa':
      return ApplicationStatus.pendingResponse;
    default:
      return ApplicationStatus.apply;
  }
}

