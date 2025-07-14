import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/job_application/job_application.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';
import 'package:manage_applications/models/requirement.dart';

class JobApplicationDetails {
  final JobApplication jobApplication;
  final Company company;
  final Company clientCompany;
  final List<JobApplicationReferent> companyReferents;
  final List<InterviewUi> interviews;
  final List<ContractUI> contracts;
  final List<Requirement> requirements;

  const JobApplicationDetails({
    required this.jobApplication,
    required this.company,
    required this.clientCompany,
    required this.companyReferents,
    required this.interviews,
    required this.requirements,
    required this.contracts,
  });

  JobApplicationDetails.fromJson(Map<String, dynamic> json)
    : jobApplication = JobApplication.fromJson(json["job_application"]),
      company = Company.fromJson(json["company"]),
      clientCompany =
          json["client_company"] != null
              ? Company.fromJson(json["client_company"])
              : Company.defaultValue(),
      companyReferents =
          json["company_referents"] != null
              ? List<JobApplicationReferent>.from(
                json["company_referents"].map(
                  (e) => JobApplicationReferent.fromJson(e),
                ),
              )
              : [],

      interviews =
          json["interviews"] != null
              ? List<InterviewUi>.from(
                json["interviews"].map((e) => InterviewUi.fromJson(e)),
              )
              : [],

      requirements =
          json["requirements"] != null
              ? List<Requirement>.from(
                json["requirements"].map((e) => Requirement.fromJson(e)),
              )
              : [],
      contracts =
          json["contracts"] != null
              ? List<ContractUI>.from(
                json["contracts"].map((e) => ContractUI.fromJson(e)),
              )
              : [];

  JobApplicationDetails copyWith({
    JobApplication? jobApplication,
    Company? company,
    Company? clientCompany,
    List<JobApplicationReferent>? companyReferents,
    List<Requirement>? requirements,
    List<ContractUI>? contracts,
    List<InterviewUi>? interviews,
  }) {
    return JobApplicationDetails(
      jobApplication: jobApplication ?? this.jobApplication,
      company: company ?? this.company,
      clientCompany: clientCompany ?? this.clientCompany,
      companyReferents: companyReferents ?? this.companyReferents,
      interviews: interviews ?? this.interviews,
      requirements: requirements ?? this.requirements,
      contracts: contracts ?? this.contracts,
    );
  }

  static JobApplicationDetails defaultValue() {
    return JobApplicationDetails(
      jobApplication: JobApplication.defaultValue(),
      companyReferents: [],
      company: Company.defaultValue(),
      clientCompany: Company.defaultValue(),
      interviews: [],
      contracts: [],
      requirements: [],
    );
  }

  @override
  String toString() {
    return '''{
      JobAppData => { ${jobApplication.toString()} }
      Company => ${company.toString()}
      ClientCompany => ${clientCompany.toString()}
      Referent => ${companyReferents.toString()}
      Requirements => [ ${requirements.toString()} ]
      Interviews => [ ${interviews.toString()} ]
      Contracts => [ ${contracts.toString()} ]
    } ''';
  }
}
