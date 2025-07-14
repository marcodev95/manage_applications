import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/repository/referent_repository.dart';
import 'package:manage_applications/repository/job_application_referents_repository.dart';

class ReferentsNotifier
    extends AutoDisposeAsyncNotifier<List<JobApplicationReferent>> {
  @override
  FutureOr<List<JobApplicationReferent>> build() async {
    final details = await ref.watch(fetchJobApplicationDetailsProvider.future);

    return details.companyReferents;
  }

  Future<OperationResult> addReferent(
    JobApplicationReferent appReferent,
  ) async {
    final applicationId = _getApplicationIdOrFailure();

    state = const AsyncLoading();

    try {
      final result = await _repository.addReferent(appReferent.referent);

      final updateReferent = appReferent.copyWith(referent: result);

      await _appReferentsRepository.addReferentToJobApplication(
        applicationId,
        updateReferent,
      );

      state = AsyncData([..._currentState, updateReferent]);

      print(state);

      return Success(data: true, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> updateReferent(
    JobApplicationReferent referent,
  ) async {
    state = const AsyncLoading();

    try {
      await _repository.updateReferent(referent.referent);

      await _appReferentsRepository.updateJobApplicationReferent(
        _getApplicationIdOrFailure(),
        referent,
      );

      final updateList =
          _currentState
              .map((e) => e.referent.id == referent.referent.id ? referent : e)
              .toList();

      state = AsyncData(updateList);

      return Success(data: referent, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> deleteReferent(int id) async {
    state = const AsyncLoading();

    try {
      await _repository.deleteReferent(id);

      final updateList =
          _currentState.where((element) => element.referent.id != id).toList();

      state = AsyncData(updateList);

      return Success(data: true, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> unlinkReferentFromJobApplication(
    int referentId,
  ) async {
    state = const AsyncLoading();

    try {
      if (_applicationId == null) throw MissingInformationError();

      await _appReferentsRepository.unlinkReferentFromJobApplication(
        _applicationId!,
        referentId,
      );

      final updateList =
          _currentState
              .where((element) => element.referent.id != referentId)
              .toList();

      state = AsyncData(updateList);

      return Success(data: true, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return mapToFailure(e, stackTrace);
    }
  }

  void linkReferentToJobApplication(JobApplicationReferent appReferent) {
    state = state.whenData((value) => [...value, appReferent]);
  }

  int _getApplicationIdOrFailure() {
    if (_applicationId == null) {
      throw MissingInformationError(error: 'ID_Candidatura non presente!');
    }

    return _applicationId!;
  }

  ReferentRepository get _repository =>
      ref.read(referentRepositoryProvider);
  JobApplicationReferentsRepository get _appReferentsRepository =>
      ref.read(jobApplicationReferentsRepositoryProvider);
  int? get _applicationId => ref.read(jobApplicationProvider).value?.id;
  List<JobApplicationReferent> get _currentState => state.value ?? [];
}

final referentsProvider = AutoDisposeAsyncNotifierProvider<
  ReferentsNotifier,
  List<JobApplicationReferent>
>(ReferentsNotifier.new);
