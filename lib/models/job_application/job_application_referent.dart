import 'package:flutter/material.dart';
import 'package:manage_applications/models/interview/referent_with_affiliation.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/job_application/job_application.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class JobApplicationReferent {
  final int? applicationId;
  final ReferentWithAffiliation referentWithAffiliation;
  final bool involvedInInterview;

  JobApplicationReferent({
    this.applicationId,
    required this.referentWithAffiliation,
    this.involvedInInterview = true,
  });

  Map<String, dynamic> toJson(int applicationId) {
    return {
      JobApplicationReferentsColumns.jobApplicationId: applicationId,
      JobApplicationReferentsColumns.referentId:
          referentWithAffiliation.referent.id,
      JobApplicationReferentsColumns.involvedInInterview: fromBoolToInt(
        involvedInInterview,
      ),
      JobApplicationReferentsColumns.referentAffiliation:
          referentWithAffiliation.affiliation.name,
    };
  }

  Map<String, dynamic> toUpdatableJson() {
    return {
      JobApplicationReferentsColumns.involvedInInterview: fromBoolToInt(
        involvedInInterview,
      ),
      JobApplicationReferentsColumns.referentAffiliation:
          referentWithAffiliation.affiliation.name,
    };
  }

  factory JobApplicationReferent.fromJson(Map<String, dynamic> map) {
    final referentJson = {
      ReferentTableColumns.id: map[ReferentTableColumns.id],
      ReferentTableColumns.name: map[ReferentTableColumns.name],
      ReferentTableColumns.email: map[ReferentTableColumns.email],
      ReferentTableColumns.role: map[ReferentTableColumns.role],
    };
    return JobApplicationReferent(
      applicationId: map[JobApplicationsTableColumns.id],
      referentWithAffiliation: ReferentWithAffiliation(
        referent: Referent.fromJson(referentJson),
        affiliation: fromStringToReferentAffiliation(
          map[JobApplicationReferentsColumns.referentAffiliation],
        ),
      ),
      involvedInInterview: fromIntToBool(
        map[JobApplicationReferentsColumns.involvedInInterview],
      ),
    );
  }

  JobApplicationReferent copyWith({
    Referent? referent,
    ReferentAffiliation? affiliation,
    bool? involvedInInterview,
    int? applicationId,
  }) {
    return JobApplicationReferent(
      referentWithAffiliation: referentWithAffiliation.copyWith(
        referent: referent ?? referentWithAffiliation.referent,
        affiliation: affiliation ?? referentWithAffiliation.affiliation
      ),
      applicationId: applicationId ?? this.applicationId,
      involvedInInterview: involvedInInterview ?? this.involvedInInterview,
    );
  }

  @override
  String toString() {
    return ''' {
        Id: $applicationId
        referentAffiliation: $referentWithAffiliation
        involvedInInterview: $involvedInInterview
      }
    ''';
  }
}

class JobApplicationReferentsColumns {
  static const tableName = 'job_application_referents';

  static const jobApplicationId = 'job_application_id';
  static const referentId = 'referent_id';
  static const involvedInInterview = 'involved_in_interview';
  static const referentAffiliation = "referent_affiliation";
}

enum ReferentAffiliation { main, client }

extension ReferentAffiliationX on ReferentAffiliation {
  Color get color {
    return switch (this) {
      ReferentAffiliation.main => Colors.blue,
      ReferentAffiliation.client => Colors.green,
    };
  }

  String get displayName {
    return switch (this) {
      ReferentAffiliation.main => 'P',
      ReferentAffiliation.client => 'C',
    };
  }

  bool get isMain => this == ReferentAffiliation.main;
}

ReferentAffiliation fromStringToReferentAffiliation(String value) {
  switch (value) {
    case 'main':
      return ReferentAffiliation.main;
    case 'client':
      return ReferentAffiliation.client;
    default:
      return ReferentAffiliation.main;
  }
}
