import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/job_data/job_application_ui.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/repository/company_applications_repository.dart';
import 'package:manage_applications/repository/job_data_repository.dart';

class ApplicationsRelatedClientCompanyNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<JobApplicationUi>, int> {
  Future<List<JobApplicationUi>> _getDatas(int companyId) async {
    return await _companyApplicationsRepository
        .getApplicationsRelatedClientCompany(companyId);
  }

  @override
  FutureOr<List<JobApplicationUi>> build(int arg) async => await _getDatas(arg);

  Future<OperationResult> removeAssociation(int jobApplicationId) async {
    state = const AsyncLoading();

    try {
      await _repository.updateClientCompanyId(null, jobApplicationId);
      state = AsyncData(await _getDatas(arg));

      return Success(data: true, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      return mapToFailure(e, stackTrace);
    }
  }

  JobDataRepository get _repository => ref.read(jobDataRepositoryProvider);

  CompanyApplicationsRepository get _companyApplicationsRepository =>
      ref.read(companyApplicationsRepositoryProvider);
}

final applicationsRelatedClientCompanyProvider = AsyncNotifierProvider
    .autoDispose
    .family<
      ApplicationsRelatedClientCompanyNotifier,
      List<JobApplicationUi>,
      int
    >(ApplicationsRelatedClientCompanyNotifier.new);
