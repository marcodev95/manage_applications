import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/job_data/job_data.dart';
import 'package:manage_applications/models/requirement.dart';

class JobApplicationDetails {
  final JobData jobData;
  final Company company;
  final Company clientCompany;
  final List<CompanyReferentUi> companyReferents;
  final List<InterviewUi> interviews;
  final List<ContractUI> contracts;
  final List<Requirement> requirements;

  const JobApplicationDetails({
    required this.jobData,
    required this.company,
    required this.clientCompany,
    required this.companyReferents,
    required this.interviews,
    required this.requirements,
    required this.contracts,
  });

  JobApplicationDetails.fromJson(Map<String, dynamic> json)
    : jobData = JobData.fromJson(json["job_data"]),
      company = Company.fromJson(json["company"]),
      clientCompany =
          json["final_company"] != null
              ? Company.fromJson(json["final_company"])
              : Company.defaultValue(),
      companyReferents =
          json["company_referents"] != null
              ? List<CompanyReferentUi>.from(
                json["company_referents"].map(
                  (e) => CompanyReferentUi.fromJson(e),
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
    JobData? jobData,
    Company? company,
    Company? clientCompany,
    List<CompanyReferentUi>? companyReferents,
    List<Requirement>? requirements,
    List<ContractUI>? contracts,
    List<InterviewUi>? interviews,
  }) {
    return JobApplicationDetails(
      jobData: jobData ?? this.jobData,
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
      jobData: JobData.defaultValue(),
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
      JobAppData => { ${jobData.toString()} }
      Company => ${company.toString()}
      ClientCompany => ${clientCompany.toString()}
      Referent => ${companyReferents.toString()}
      Requirements => [ ${requirements.toString()} ]
      Interviews => [ ${interviews.toString()} ]
      Contracts => [ ${contracts.toString()} ]
    } ''';
  }
}
