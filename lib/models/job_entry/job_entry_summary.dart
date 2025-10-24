import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/job_application/job_application.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_utility.dart';

class JobEntrySummary extends Equatable {
  final int id;
  final String position;
  final ApplicationStatus status;
  final DateTime applyDate;
  final String? clientCompanyName;
  final String? mainCompanyName;

  const JobEntrySummary({
    required this.id,
    required this.position,
    required this.status,
    required this.applyDate,
    this.clientCompanyName,
    this.mainCompanyName,
  });

  JobEntrySummary.fromJson(Map<String, dynamic> json)
    : id = json[JobApplicationsTableColumns.id],
      position = json[JobApplicationsTableColumns.position],
      status = applicationStatusFromString(
        json[JobApplicationsTableColumns.applicationStatus],
      ),
      applyDate = DateTime.parse(json[JobApplicationsTableColumns.applyDate]),
      clientCompanyName = json['client'],
      mainCompanyName = json['main'];

  @override
  List<Object?> get props => [
    id,
    position,
    status,
    applyDate,
    clientCompanyName,
    mainCompanyName,
  ];
}
