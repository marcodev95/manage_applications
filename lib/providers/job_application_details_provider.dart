import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/job_application_details.dart';
import 'package:manage_applications/models/job_data/job_data.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobApplicationDetailsNotifier
    extends AutoDisposeNotifier<JobApplicationDetails> {
  @override
  JobApplicationDetails build() {
    return ref
        .watch(fetchJobApplicationDetailsProvider)
        .maybeWhen(
          data: (data) => data,
          orElse: () => JobApplicationDetails.defaultValue(),
        );
  }

  void updateJobData(JobData jobData) {
    state = state.copyWith(jobData: jobData);
  }

  void updateCompany(Company company) {
    state = state.copyWith(company: company);
  }

  void updateClientCompany(Company company) {
    state = state.copyWith(clientCompany: company);
  }

  void updateCompanyReferentsList(List<CompanyReferentUi> referents) {
    state = state.copyWith(companyReferents: referents);
  }

  void updateInterviews(List<InterviewUi> interviews) {
    state = state.copyWith(interviews: interviews);
  }

  void updateContract(List<ContractUI> contracts) {
    state = state.copyWith(contracts: contracts);
  }
}

final jobApplicationDetailsProvider1 = AutoDisposeNotifierProvider<
  JobApplicationDetailsNotifier,
  JobApplicationDetails
>(JobApplicationDetailsNotifier.new);
