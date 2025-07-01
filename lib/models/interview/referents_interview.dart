import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_utility.dart';

class SelectedReferentsForInterview extends Equatable{
  final int? id;
  final CompanyReferentUi referent;

  const SelectedReferentsForInterview({this.id, required this.referent});

  SelectedReferentsForInterview.fromJson(Map<String, dynamic> json)
    : id = json[ReferentsInterviewTableColumns.id],
      referent = CompanyReferentUi(
        id: json[CompanyReferentTableColumns.id],
        name: json[CompanyReferentTableColumns.name],
        role: roleTypeFromString(json[CompanyReferentTableColumns.role]),
        email: json[CompanyReferentTableColumns.email],
        companyType: fromStringToCompanyType(json[CompanyReferentTableColumns.companyType])
      );

  static Map<String, dynamic> toJson(int interviewId, int referentId) => {
    ReferentsInterviewTableColumns.interviewId: interviewId,
    ReferentsInterviewTableColumns.referentId: referentId,
  };

  SelectedReferentsForInterview copyWith({int? id, CompanyReferentUi? referent}) {
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
