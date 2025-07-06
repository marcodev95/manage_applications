import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/job_data/job_data.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_utility.dart';

abstract class JobApplicationBaseUI extends Equatable {
  final int? id;
  final String position;
  final DateTime applyDate;
  final ApplicationStatus applicationStatus;
  final String link;

  const JobApplicationBaseUI({
    this.id,
    required this.position,
    required this.applyDate,
    required this.applicationStatus,
    required this.link,
  });

  @override
  List<Object?> get props => [id, position, applyDate, applicationStatus, link];
}

class JobApplicationBase extends JobApplicationBaseUI {
  const JobApplicationBase({
    super.id,
    required super.position,
    required super.applyDate,
    required super.applicationStatus,
    required super.link,
  });

  factory JobApplicationBase.fromJson(Map<String, dynamic> json) {
    return JobApplicationBase(
      id: json[JobApplicationsTableColumns.id],
      position: json[JobApplicationsTableColumns.position],
      applyDate: DateTime.parse(json[JobApplicationsTableColumns.applyDate]),
      applicationStatus: applicationStatusFromString(
        json[JobApplicationsTableColumns.applicationStatus],
      ),
      link: json[JobApplicationsTableColumns.websiteUrl],
    );
  }
}

class JobApplicationUi extends Equatable {
  final int? id;
  final String position;
  final CompanyRef? companyRef;
  final DateTime applyDate;
  final ApplicationStatus applicationStatus;
  final String link;

  const JobApplicationUi({
    this.id,
    required this.position,
    this.companyRef,
    required this.applyDate,
    required this.applicationStatus,
    required this.link,
  });

  JobApplicationUi.fromJson(Map<String, dynamic> json)
    : id = json[JobApplicationsTableColumns.id],
      position = json[JobApplicationsTableColumns.position],
      companyRef =
          json[CompanyTableColumns.id] != null
              ? CompanyRef.fromJson(json)
              : null,
      applyDate = DateTime.parse(json[JobApplicationsTableColumns.applyDate]),
      applicationStatus = applicationStatusFromString(
        json[JobApplicationsTableColumns.applicationStatus],
      ),
      link = json[JobApplicationsTableColumns.websiteUrl];

  JobApplicationUi copyWith({
    int? id,
    String? position,
    DateTime? applyDate,
    CompanyRef? companyRef,
    ApplicationStatus? applicationStatus,
    String? link,
  }) {
    return JobApplicationUi(
      id: id ?? this.id,
      position: position ?? this.position,
      companyRef: companyRef ?? this.companyRef,
      applyDate: applyDate ?? this.applyDate,
      applicationStatus: applicationStatus ?? this.applicationStatus,
      link: link ?? this.link,
    );
  }

  @override
  List<Object?> get props => [
    id,
    position,
    companyRef,
    applyDate,
    applicationStatus,
    link,
  ];

  @override
  String toString() {
    return '''
    {
      Id => $id
      Position => $position
      CompanyName => $companyRef
      ApplyDate => $applyDate
      ApplicationStatus => $applicationStatus
      Link => $link
    } ''';
  }
}
