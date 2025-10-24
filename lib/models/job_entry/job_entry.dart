import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/job_application/job_application.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_utility.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class JobEntry extends Equatable {
  final int? id;
  final String position;
  final JobDataWorkType workType;
  final String url;
  final String? workPlace;
  final String? dayInOffice;
  final DateTime createAt;

  JobEntry({
    this.id,
    required this.position,
    required this.workType,
    required this.url,
    this.workPlace,
    this.dayInOffice,
    DateTime? createAt,
  }) : createAt = createAt ?? DateTime.now();

  JobEntry.fromJson(Map<String, dynamic> json)
    : id = json[JobApplicationsTableColumns.id],
      position = json[JobApplicationsTableColumns.position],
      url = json[JobApplicationsTableColumns.websiteUrl],
      createAt = DateTime.parse(json[JobApplicationsTableColumns.createAt]),
      workType = workTypeFromString(json[JobApplicationsTableColumns.workType]),
      workPlace = json[JobApplicationsTableColumns.workPlace],
      dayInOffice = json[JobApplicationsTableColumns.dayInOffice];

  Map<String, dynamic> toJson() => {
    JobApplicationsTableColumns.position: position,
    JobApplicationsTableColumns.workType: workType.name,
    JobApplicationsTableColumns.websiteUrl: url,
    JobApplicationsTableColumns.createAt: dbFormat.format(createAt),
    JobApplicationsTableColumns.workPlace: workPlace,
    JobApplicationsTableColumns.dayInOffice: dayInOffice,
  };

  JobEntry copyWith({
    int? id,
    String? position,
    JobDataWorkType? workType,
    String? url,
    String? workPlace,
    String? dayInOffice,
    DateTime? createAt,
  }) {
    return JobEntry(
      id: id ?? this.id,
      position: position ?? this.position,
      workType: workType ?? this.workType,
      url: url ?? this.url,
      createAt: createAt ?? this.createAt,
      dayInOffice: dayInOffice ?? this.dayInOffice,
      workPlace: workPlace ?? this.workPlace,
    );
  }

  @override
  String toString() {
    return 'JobEntry('
        'id: $id, '
        'position: $position, '
        'workType: $workType, '
        'url: $url, '
        'createAt: ${createAt.toIso8601String()}, '
        'workPlace: $workPlace ,'
        'dayInOffice: $dayInOffice '
        ')';
  }

  @override
  List<Object?> get props => [
    id,
    position,
    url,
    createAt,
    workType,
    workPlace,
    dayInOffice,
  ];
}
