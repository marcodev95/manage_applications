import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/job_application/job_application_referent.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/shared/company_option.dart';

class ReferentDetails {
  final JobApplicationReferent jobApplicationReferent;
  final CompanyOption company;

  const ReferentDetails({
    required this.jobApplicationReferent,
    required this.company,
  });

  ReferentDetails.fromJson(Map<String, dynamic> json)
    : jobApplicationReferent = JobApplicationReferent.fromJson(json),
      company = CompanyOption(
        CompanyRef(id: json['company_id'], name: json['company_name']),
        fromStringToReferentAffiliation(
          json[JobApplicationReferentsColumns.referentAffiliation],
        ),
      );

  static Referent toDB(ReferentDetails details) {
    final referent =
        details.jobApplicationReferent.referentWithAffiliation.referent;
    return Referent(
      id: referent.id,
      name: referent.name,
      role: referent.role,
      email: referent.email,
      phoneNumber: referent.phoneNumber,
      companyId: details.company.companyRef.id,
    );
  }

  @override
  String toString() {
    return ''' 
      {
        jobApplicationReferent: $jobApplicationReferent
        Company: $company
      }
    ''';
  }
}
