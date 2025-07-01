/* import 'package:manage_applications/models/job_announcement/announcement.dart';
import 'package:manage_applications/models/job_application/job_application.dart';

class JobAnnouncement extends Announcement {
  final String position;
  final String workType;
  final String? dayInOffice;
  final String? experience;

  JobAnnouncement({
    required this.position,
    required this.workType,
    this.dayInOffice,
    this.experience,
    required super.link,
  });

  @override
  JobAnnouncement copyWith({
    String? position,
    String? link,
    String? dayInOffice,
    String? workType,
    String? experience,
  }) {
    return JobAnnouncement(
      position: position ?? this.position,
      dayInOffice: dayInOffice ?? this.dayInOffice,
      link: link ?? this.link,
      workType: workType ?? this.workType,
      experience: experience ?? this.experience,
    );
  }

  JobAnnouncement.fromJson(Map<String, dynamic> json) :
        position = json[JobApplicationTable.position],
        dayInOffice = json[JobApplicationTable.dayInOffice],
        workType = json[JobApplicationTable.workType] ?? "",
        experience = json[JobApplicationTable.experience],
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        JobApplicationTable.position: position,
        JobApplicationTable.link: link,
        JobApplicationTable.workType: workType,
        JobApplicationTable.dayInOffice: dayInOffice,
        JobApplicationTable.experience: experience,
      };

  @override
  String toString() {
    return '''
      Position => $position
      Link => $link
      WorkType => $workType
      DayInOffice => $dayInOffice
      Experience => $experience
    ''';
  }

  static JobAnnouncement reset() {
    return JobAnnouncement(position: "", link: "", workType: "hybrid");
  }
}


 */