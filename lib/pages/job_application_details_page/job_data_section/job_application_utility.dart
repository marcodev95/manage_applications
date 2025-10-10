import 'package:flutter/material.dart';
import 'package:manage_applications/providers/job_application_filter.dart';

enum JobDataWorkType { hybrid, remote, onSite }

extension JobDataWorkTypeX on JobDataWorkType {
  String get displayName {
    switch (this) {
      case JobDataWorkType.hybrid:
        return 'Ibrido';
      case JobDataWorkType.remote:
        return 'Remoto';
      case JobDataWorkType.onSite:
        return 'Presenza';
    }
  }

  bool get isRemote {
    return this == JobDataWorkType.remote;
  }
}

JobDataWorkType workTypeFromString(String value) {
  switch (value) {
    case 'hybrid':
      return JobDataWorkType.hybrid;
    case 'remote':
      return JobDataWorkType.remote;
    case 'onSite':
      return JobDataWorkType.onSite;
    default:
      return JobDataWorkType.hybrid;
  }
}

enum ApplicationStatus { apply, interview, pendingResponse }

extension ApplicationStatusX on ApplicationStatus {
  String get displayName {
    switch (this) {
      case ApplicationStatus.apply:
        return 'Candidato';
      case ApplicationStatus.interview:
        return 'Colloquio';
      case ApplicationStatus.pendingResponse:
        return 'In attesa';
    }
  }

  Color get displayChipColor {
    switch (this) {
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
    case 'apply':
      return ApplicationStatus.apply;
    case 'interview':
      return ApplicationStatus.interview;
    case 'pendingResponse':
      return ApplicationStatus.pendingResponse;
    default:
      return ApplicationStatus.apply;
  }
}
