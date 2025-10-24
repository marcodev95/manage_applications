import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/job_entry/job_entry_summary.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';
import 'package:manage_applications/repository/company_applications_repository.dart';

class MainCompanyApplicationsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<JobEntrySummary>, int> {
  Future<List<JobEntrySummary>> _getDatas(int companyId) async {
    return await _companyApplicationsRepository.fetchApplicationsForMainCompany(
      companyId,
    );
  }

  @override
  FutureOr<List<JobEntrySummary>> build(int arg) async => await _getDatas(arg);

  Future<OperationResult> deleteJobApplication(int jobApplicationId) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(paginatorApplicationsUIProvider.notifier)
          .deleteJobApplication(jobApplicationId);

      state = AsyncData(await _getDatas(arg));

      return Success(data: true, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  CompanyApplicationsRepository get _companyApplicationsRepository =>
      ref.read(companyApplicationsRepositoryProvider);
}

final mainCompanyApplicationsProvider = AsyncNotifierProvider.autoDispose
    .family<MainCompanyApplicationsNotifier, List<JobEntrySummary>, int>(
      MainCompanyApplicationsNotifier.new,
    );
