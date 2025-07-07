import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/job_application/job_application.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';
import 'package:manage_applications/repository/job_data_repository.dart';

class JobApplicationNotifier extends AutoDisposeAsyncNotifier<JobApplication> {
  @override
  FutureOr<JobApplication> build() async {
    final details = await ref.watch(fetchJobApplicationDetailsProvider.future);

    debugPrint('Details => $details');

    return details.jobApplication;
  }

  Future<OperationResult> addJobApplication(
    JobApplication jobApplication,
  ) async {
    state = const AsyncLoading();

    try {
      final lastData = await _repository.addJobApplication(jobApplication);

      state = AsyncData(lastData);

      debugPrint('Create => $state');

      await _applicationsUINotifier.handleAddJobApplication();

      return Success(data: lastData, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> updateJobApplication(
    JobApplication jobApplication,
  ) async {
    state = const AsyncLoading();

    try {
      await _repository.updateJobApplication(jobApplication);

      state = AsyncData(jobApplication);

      debugPrint('Update => $state');

      await _applicationsUINotifier.reloadCurrentPage();

      return Success(data: true, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  JobApplicationRepository get _repository =>
      ref.read(jobApplicationRepositoryProvider);
  JobApplicationsPaginatorNotifier get _applicationsUINotifier =>
      ref.read(paginatorApplicationsUIProvider.notifier);
}

final jobApplicationProvider =
    AutoDisposeAsyncNotifierProvider<JobApplicationNotifier, JobApplication>(
      () {
        return JobApplicationNotifier();
      },
    );
