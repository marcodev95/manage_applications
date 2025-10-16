import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/providers/companies_paginator_notifier.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';
import 'package:manage_applications/repository/company_repository.dart';
import 'package:manage_applications/repository/job_data_repository.dart';

class AppliedCompanyFormNotifier extends AutoDisposeAsyncNotifier<Company> {
  @override
  FutureOr<Company> build() async {
    final details = await ref.watch(fetchJobApplicationDetailsProvider.future);

    return details.company;
  }

  Future<OperationResult> addCompany(Company company) async {
    state = const AsyncLoading();

    try {
      final lastCompany = await _repository.addCompany(company);

      await _updateJobApplicationCompany(lastCompany);

      await _companiesNotifier.handleAddCompany();

      state = AsyncData(lastCompany);

      return Success(data: company, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> selectCompany(Company company) async {
    try {
      await _updateJobApplicationCompany(company);
      state = AsyncData(company);

      return Success(data: company, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<void> _updateJobApplicationCompany(Company company) async {
    final jobApplicationId = ref.read(jobApplicationProvider).value?.jobEntry.id;

    if (jobApplicationId == null) {
      throw MissingInformationError(error: 'ID_Candidatura non presente!');
    }

    await _jobApplicationRepository.updateCompanyId(
      company.id!,
      jobApplicationId,
    );

    _applicationsUINotifier.updateCompanyRef(
      id: jobApplicationId,
      companyRef: CompanyRef(id: company.id!, name: company.name),
    );
  }

  JobApplicationsPaginatorNotifier get _applicationsUINotifier =>
      ref.read(paginatorApplicationsUIProvider.notifier);
  CompanyRepository get _repository => ref.read(companyRepositoryProvider);
  JobApplicationRepository get _jobApplicationRepository =>
      ref.read(jobApplicationRepositoryProvider);
  CompaniesPaginatorNotifier get _companiesNotifier =>
      ref.read(companiesPaginatorProvider.notifier);
}

final appliedCompanyFormProvider =
    AutoDisposeAsyncNotifierProvider<AppliedCompanyFormNotifier, Company>(
      AppliedCompanyFormNotifier.new,
    );
