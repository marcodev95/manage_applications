import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/job_application/job_application_ui.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/repository/company_applications_repository.dart';
import 'package:manage_applications/repository/job_data_repository.dart';

class ClientCompanyApplicationsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<JobApplicationUi>, int> {
  Future<List<JobApplicationUi>> _getDatas(int companyId) async {
    return await _companyApplicationsRepository
        .fetchApplicationsForClientCompany(companyId);
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
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  JobApplicationRepository get _repository =>
      ref.read(jobApplicationRepositoryProvider);

  CompanyApplicationsRepository get _companyApplicationsRepository =>
      ref.read(companyApplicationsRepositoryProvider);
}

final clientCompanyApplicationsProvider = AsyncNotifierProvider.autoDispose
    .family<ClientCompanyApplicationsNotifier, List<JobApplicationUi>, int>(
      ClientCompanyApplicationsNotifier.new,
    );
