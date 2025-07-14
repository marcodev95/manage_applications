import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';

class SelectedReferentsForInterview extends Equatable{
  final int? id;
  final JobApplicationReferent referent;

  const SelectedReferentsForInterview({this.id, required this.referent});

  SelectedReferentsForInterview.fromJson(Map<String, dynamic> json)
    : id = json[ReferentsInterviewTableColumns.id],
      referent = JobApplicationReferent.fromJson(json);

  static Map<String, dynamic> toJson(int interviewId, int referentId) => {
    ReferentsInterviewTableColumns.interviewId: interviewId,
    ReferentsInterviewTableColumns.referentId: referentId,
  };

  SelectedReferentsForInterview copyWith({int? id, JobApplicationReferent? referent}) {
    return SelectedReferentsForInterview(
      id: id ?? this.id,
      referent: referent ?? this.referent,
    );
  }

  @override
  String toString() {
    return '''__ReferentsInterview {
      id => $id
      referent => $referent
    } ''';
  }
  
  @override
  List<Object?> get props => [id, referent];
}

const referentsInterviewTable = 'referents_interview';

class ReferentsInterviewTableColumns {
  static const id = '_referents_interview_id';
  static const interviewId = 'interview_id';
  static const referentId = 'referent_id';
}
