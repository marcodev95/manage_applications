import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/interview/referent_with_affiliation.dart';

class SelectedReferentsForInterview extends Equatable {
  final int? id;
  final ReferentWithAffiliation referentWithAffiliation;

  const SelectedReferentsForInterview({
    this.id,
    required this.referentWithAffiliation,
  });

  SelectedReferentsForInterview.fromJson(Map<String, dynamic> json)
    : id = json[ReferentsInterviewTableColumns.id],
      referentWithAffiliation = ReferentWithAffiliation.fromJson(json);

  static Map<String, dynamic> toJson(int interviewId, int referentId) => {
    ReferentsInterviewTableColumns.interviewId: interviewId,
    ReferentsInterviewTableColumns.referentId: referentId,
  };

  @override
  String toString() {
    return '''__ReferentsInterview {
      id => $id
      referent => $referentWithAffiliation
    } ''';
  }

  @override
  List<Object?> get props => [id, referentWithAffiliation];
}

const referentsInterviewTable = 'referents_interview';

class ReferentsInterviewTableColumns {
  static const id = '_referents_interview_id';
  static const interviewId = 'interview_id';
  static const referentId = 'referent_id';
}
