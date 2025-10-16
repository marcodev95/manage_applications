import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/providers/companies_paginator_notifier.dart';
import 'package:manage_applications/repository/company_repository.dart';
import 'package:manage_applications/repository/job_data_repository.dart';

class ClientCompanyFormNotifier extends AutoDisposeAsyncNotifier<Company> {
  @override
  FutureOr<Company> build() async {
    final details = await ref.watch(fetchJobApplicationDetailsProvider.future);

    return details.clientCompany;
  }

  Future<OperationResult> addClientCompany(Company company) async {
    state = const AsyncLoading();

    try {
      final lastCompany = await _repository.addCompany(company);

      await _updateClientCompanyId(lastCompany);

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
      await _updateClientCompanyId(company);

      state = AsyncData(company);

      return Success(data: company, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<void> _updateClientCompanyId(Company company) async {
    final jobApplicationId = ref.read(jobApplicationProvider).value?.jobEntry.id;

    if (jobApplicationId == null) {
      throw MissingInformationError(error: 'ID_Candidatura non presente');
    }

    await _jobApplicationRepository.updateClientCompanyId(company.id!, jobApplicationId);
  }

  CompanyRepository get _repository => ref.read(companyRepositoryProvider);
  JobApplicationRepository get _jobApplicationRepository =>
      ref.read(jobApplicationRepositoryProvider);
  CompaniesPaginatorNotifier get _companiesNotifier =>
      ref.read(companiesPaginatorProvider.notifier);
}

final clientCompanyFormProvider =
    AutoDisposeAsyncNotifierProvider<ClientCompanyFormNotifier, Company>(
      ClientCompanyFormNotifier.new,
    );
