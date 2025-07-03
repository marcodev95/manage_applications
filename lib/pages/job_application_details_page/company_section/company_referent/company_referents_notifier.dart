import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/repository/company_referent_repository.dart';

class CompanyReferentsNotifier
    extends AutoDisposeAsyncNotifier<List<CompanyReferentUi>> {
  @override
  FutureOr<List<CompanyReferentUi>> build() async {
    final details = await ref.watch(fetchJobApplicationDetailsProvider.future);

    return details.companyReferents;
  }

  Future<OperationResult> addCompanyReferent(
    CompanyReferentDetails referent,
  ) async {
    final applicationId = _getApplicationIdOrFailure();

    state = const AsyncLoading();

    try {
      final lastReferent = await _repository.addCompanyReferent(
        referent,
        applicationId,
      );

      state = AsyncData([
        ..._currentState,
        CompanyReferentDetails.toUI(lastReferent),
      ]);

      return Success(data: lastReferent, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> updateCompanyReferent(
    CompanyReferentDetails referent,
  ) async {
    final applicationId = _getApplicationIdOrFailure();

    state = const AsyncLoading();

    try {
      await _repository.updateCompanyReferent(
        CompanyReferentDetails.toDB(referent, applicationId),
      );

      final updateList =
          _currentState
              .map(
                (e) =>
                    e.id == referent.id
                        ? CompanyReferentDetails.toUI(referent)
                        : e,
              )
              .toList();

      state = AsyncData(updateList);

      return Success(data: referent, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> deleteCompanyReferent(int id) async {
    state = const AsyncLoading();

    try {
      await _repository.deleteCompanyReferent(id);

      final updateList =
          _currentState.where((element) => element.id != id).toList();

      state = AsyncData(updateList);

      return Success(data: true, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return mapToFailure(e, stackTrace);
    }
  }

  int _getApplicationIdOrFailure() {
    if (_applicationId == null) {
      throw MissingInformationError(error: 'ID_Application non presente!');
    }

    return _applicationId!;
  }

  CompanyReferentRepository get _repository =>
      ref.read(companyReferentRepositoryProvider);
  int? get _applicationId => ref.read(jobDataProvider).value?.id;
  List<CompanyReferentUi> get _currentState => state.value ?? [];
}

final companyReferentsProvider = AutoDisposeAsyncNotifierProvider<
  CompanyReferentsNotifier,
  List<CompanyReferentUi>
>(CompanyReferentsNotifier.new);
