import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/job_entry/job_entry.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_utility.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class JobApplication extends Equatable {
  final JobEntry jobEntry;

  final ApplicationStatus applicationStatus;
  final DateTime applyDate;
  final String? experience;

  const JobApplication({
    required this.jobEntry,
    required this.applicationStatus,
    required this.applyDate,
    this.experience,
  });

  JobApplication.fromJson(Map<String, dynamic> json)
    : jobEntry = JobEntry.fromJson(json['job_entry']),
      applyDate = DateTime.parse(
        json['j_a'][JobApplicationsTableColumns.applyDate],
      ),
      applicationStatus = applicationStatusFromString(
        json['j_a'][JobApplicationsTableColumns.applicationStatus],
      ),
      experience = json['j_a'][JobApplicationsTableColumns.experience];

  JobApplication copyWith({
    JobEntry? jobEntry,
    ApplicationStatus? applicationStatus,
    DateTime? applyDate,
    String? experience,
  }) {
    return JobApplication(
      jobEntry: jobEntry ?? this.jobEntry,
      applicationStatus: applicationStatus ?? this.applicationStatus,
      applyDate: applyDate ?? this.applyDate,
      experience: experience ?? this.experience,
    );
  }

  Map<String, dynamic> toJson() {
    final data = jobEntry.toJson();

    data.addAll({
      JobApplicationsTableColumns.applyDate: dbFormat.format(applyDate),
      JobApplicationsTableColumns.applicationStatus: applicationStatus.name,
      JobApplicationsTableColumns.experience: experience,
    });

    return data;
  }

  @override
  String toString() {
    return ''' 
      jobEntry => $jobEntry
      ApplyDate => $applyDate 
      Status => $applicationStatus 
      ''';
  }

  static JobApplication defaultValue() {
    return JobApplication(
      jobEntry: JobEntry(
        position: '',
        workType: JobDataWorkType.hybrid,
        url: '',
      ),
      applicationStatus: ApplicationStatus.apply,
      applyDate: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [applicationStatus];
}

const String jobApplicationsTable = "job_applications_table";

class JobApplicationsTableColumns {
  static String id = "_id_job_application";
  static String applyDate = "apply_date";
  static String position = "position";
  static String createAt = "create_at";
  static String applicationStatus = "job_application_status";
  static String websiteUrl = "website_url";
  static String workType = "work_type";
  static String dayInOffice = "day_in_office";
  static String experience = "experience";
  static String workPlace = "work_place";
  static String companyId = "fk_company_id";
  static String clientCompanyId = "client_company_id";
}