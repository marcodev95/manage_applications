import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/job_entry/job_entry_summary.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/repository/company_applications_repository.dart';
import 'package:manage_applications/repository/job_application_referents_repository.dart';
import 'package:manage_applications/repository/job_data_repository.dart';

class ClientCompanyApplicationsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<JobEntrySummary>, int> {
  Future<List<JobEntrySummary>> _getDatas(int companyId) async {
    return await _companyApplicationsRepository
        .fetchApplicationsForClientCompany(companyId);
  }

  @override
  FutureOr<List<JobEntrySummary>> build(int arg) async => await _getDatas(arg);

  Future<OperationResult> removeAssociation(
    int jobApplicationId,
    int companyId,
  ) async {
    state = const AsyncLoading();

    try {
      await _applicationReferentsRepository
          .unlinkCompanyReferentsFromJobApplication(
            jobApplicationId,
            companyId,
          );
      await _repository.updateClientCompanyId(null, jobApplicationId);
      state = AsyncData(await _getDatas(arg));

      return Success(data: true, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  JobApplicationRepository get _repository =>
      ref.read(jobApplicationRepositoryProvider);

  CompanyApplicationsRepository get _companyApplicationsRepository =>
      ref.read(companyApplicationsRepositoryProvider);

  JobApplicationReferentsRepository get _applicationReferentsRepository =>
      ref.read(jobApplicationReferentsRepositoryProvider);
}

final clientCompanyApplicationsProvider = AsyncNotifierProvider.autoDispose
    .family<ClientCompanyApplicationsNotifier, List<JobEntrySummary>, int>(
      ClientCompanyApplicationsNotifier.new,
    );
