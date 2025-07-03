import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_form_controller.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/providers/companies_paginator_notifier.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';
import 'package:manage_applications/repository/company_repository.dart';
import 'package:manage_applications/repository/job_data_repository.dart';

class AppliedCompanyFormController extends AutoDisposeAsyncNotifier<Company> {
  @override
  FutureOr<Company> build() async {
    final details = await ref.watch(fetchJobApplicationDetailsProvider.future);

    return details.company;
  }

  Future<OperationResult> addCompany(Company company) async {
    state = const AsyncLoading();

    try {
      final lastCompany = await _repository.addCompany(company);

      final jobDataId = ref.read(jobDataFormController).value?.id;

      if (jobDataId == null) {
        throw MissingInformationError(error: 'ID_JobData non presente!');
      }

      await _jobDataRepository.updateCompanyId(lastCompany.id!, jobDataId);

      _applicationsUINotifier.updateCompanyRef(
        id: jobDataId,
        companyRef: CompanyRef(id: lastCompany.id!, name: lastCompany.name),
      );

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
      final jobDataId = ref.read(jobDataFormController).value?.id;

      if (jobDataId == null) {
        throw MissingInformationError(error: 'ID_Candidatura non presente!');
      }

      await _jobDataRepository.updateCompanyId(company.id!, jobDataId);

      _applicationsUINotifier.updateCompanyRef(
        id: jobDataId,
        companyRef: CompanyRef(id: company.id!, name: company.name),
      );

      state = AsyncData(company);

      return Success(data: company, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  JobApplicationsPaginatorNotifier get _applicationsUINotifier =>
      ref.read(paginatorApplicationsUIProvider.notifier);

  CompanyRepository get _repository => ref.read(companyRepositoryProvider);
  JobDataRepository get _jobDataRepository =>
      ref.read(jobDataRepositoryProvider);
  CompaniesPaginatorNotifier get _companiesNotifier =>
      ref.read(companiesPaginatorProvider.notifier);
}

final appliedCompanyFormController =
    AutoDisposeAsyncNotifierProvider<AppliedCompanyFormController, Company>(
      AppliedCompanyFormController.new,
    );
