import 'package:equatable/equatable.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_utility.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class JobData extends Equatable {
  final int? id;
  final ApplicationStatus applicationStatus;
  final DateTime applyDate;
  final String position;
  final JobDataWorkType workType;
  final String websiteUrl;
  final String? dayInOffice;
  final String? experience;

  const JobData({
    this.id,
    required this.applicationStatus,
    required this.applyDate,
    required this.position,
    required this.workType,
    required this.websiteUrl,
    this.dayInOffice,
    this.experience,
  });

  JobData.fromJson(Map<String, dynamic> json)
      : id = json[JobDataTableColumns.id],
        applyDate = DateTime.parse(json[JobDataTableColumns.applyDate]),
        applicationStatus = applicationStatusFromString(json[JobDataTableColumns.applicationStatus]),
        position = json[JobDataTableColumns.position],
        dayInOffice = json[JobDataTableColumns.dayInOffice],
        workType = workTypeFromString(json[JobDataTableColumns.workType]),
        websiteUrl = json[JobDataTableColumns.websiteUrl],
        experience = json[JobDataTableColumns.experience];

  JobData copyWith({
    int? id,
    ApplicationStatus? applicationStatus,
    DateTime? applyDate,
    String? position,
    String? websiteUrl,
    String? dayInOffice,
    JobDataWorkType? workType,
    String? experience,
  }) {
    return JobData(
      id: id ?? this.id,
      applicationStatus: applicationStatus ?? this.applicationStatus,
      applyDate: applyDate ?? this.applyDate,
      position: position ?? this.position,
      dayInOffice: dayInOffice ?? this.dayInOffice,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      workType: workType ?? this.workType,
      experience: experience ?? this.experience,
    );
  }

  Map<String, dynamic> toJson() => {
        JobDataTableColumns.applyDate: dbFormat.format(applyDate),
        JobDataTableColumns.applicationStatus: applicationStatus.name,
        JobDataTableColumns.position: position,
        JobDataTableColumns.websiteUrl: websiteUrl,
        JobDataTableColumns.workType: workType.name,
        JobDataTableColumns.dayInOffice: dayInOffice,
        JobDataTableColumns.experience: experience,
      };

  @override
  String toString() {
    return ''' 
      Id => $id 
      Position => $position
      ApplyDate => $applyDate 
      Status => $applicationStatus 
      Url => $websiteUrl
      WorkType => $workType
      DayInOffice => $dayInOffice
      ''';
  } 

  static JobData defaultValue() {
    return JobData(
      applicationStatus: ApplicationStatus.apply,
      applyDate: DateTime.now(),
      position: "",
      workType: JobDataWorkType.hybrid,
      websiteUrl: "",
    );
  }

  @override
  List<Object?> get props => [id, position];
}

const String jobDataTable = "job_data_table";

class JobDataTableColumns {
  static String id = "_id_job_data";
  static String applyDate = "apply_date";
  static String position = "position";
  static String applicationStatus = "job_data_status";
  static String websiteUrl = "website_url";
  static String workType = "work_type";
  static String dayInOffice = "day_in_office";
  static String experience = "experience";
  static String companyId = "fk_company_id";
  static String clientCompanyId = "client_company_id";
}
