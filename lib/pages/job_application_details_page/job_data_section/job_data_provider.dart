import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/job_data/job_data.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';
import 'package:manage_applications/repository/job_data_repository.dart';

class JobDataNotifier extends AutoDisposeAsyncNotifier<JobData> {
  @override
  FutureOr<JobData> build() async {
    final details = await ref.watch(fetchJobApplicationDetailsProvider.future);

    debugPrint('Details => $details');

    return details.jobData;
  }

  Future<OperationResult> addJobData(JobData jobData) async {
    state = const AsyncLoading();

    try {
      final lastData = await _repository.addJobData(jobData);

      state = AsyncData(lastData);

      debugPrint('Create => $state');

      await _applicationsUINotifier.handleAddJobApplication();

      return Success(data: lastData, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> updateJobData(JobData jobData) async {
    state = const AsyncLoading();

    try {
      await _repository.updateJobData(jobData);

      state = AsyncData(jobData);

      debugPrint('Update => $state');

      await _applicationsUINotifier.reloadCurrentPage();

      return Success(data: true, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  JobDataRepository get _repository => ref.read(jobDataRepositoryProvider);
  JobApplicationsPaginatorNotifier get _applicationsUINotifier =>
      ref.read(paginatorApplicationsUIProvider.notifier);
}

final jobDataProvider =
    AutoDisposeAsyncNotifierProvider<JobDataNotifier, JobData>(() {
      return JobDataNotifier();
    });
