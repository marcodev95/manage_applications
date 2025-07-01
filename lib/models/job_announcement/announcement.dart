/* import 'package:manage_applications/models/job_application/job_application.dart';

class Announcement {
  final String link;

  Announcement({required this.link});

  Announcement.fromJson(Map<String, dynamic> json)
      : link = json[JobApplicationTable.link];

  Map<String, dynamic> toJson() => {JobApplicationTable.link: link};

  Announcement copyWith({String? link}) {
    return Announcement(
        link: link ?? this.link);
  }

  @override
  String toString() {
    return "Link => $link";
  }
}
 */