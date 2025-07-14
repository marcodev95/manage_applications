import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/client_company/client_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referents_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';
import 'package:manage_applications/repository/referent_repository.dart';
import 'package:manage_applications/repository/job_application_referents_repository.dart';

class ReferentsSelectorNotifier
    extends AutoDisposeAsyncNotifier<List<ReferentWithCompany>> {
  @override
  FutureOr<List<ReferentWithCompany>> build() async {
    final mainId = ref.watch(appliedCompanyFormProvider).value?.id;
    final clientId = ref.watch(clientCompanyFormProvider).value?.id;
    final applicationId = ref.watch(jobApplicationProvider).value?.id;

    if (mainId == null || applicationId == null) {
      final missing = [
        if (mainId == null) 'azienda principale (mainId)',
        if (applicationId == null) 'candidatura (applicationId)',
      ].join(' e ');

      throw MissingInformationError(
        message: 'Mancano informazioni obbligatorie: $missing',
      );
    }

    return await _referentRepo.getAvailableCompanyReferents(
      mainId,
      applicationId,
      clientId,
    );
  }

  Future<OperationResult<bool>> associate(ReferentWithCompany referent) async {
    state = const AsyncLoading();

    try {
      final applicationId = ref.watch(jobApplicationProvider).value?.id;
      final appliedCompanyId = ref.watch(appliedCompanyFormProvider).value?.id;

      if (applicationId == null || appliedCompanyId == null) {
        final missing = [
          if (appliedCompanyId == null) 'azienda principale (appliedCompanyId)',
          if (applicationId == null) 'candidatura (applicationId)',
        ].join(' e ');

        throw MissingInformationError(
          message: 'Mancano informazioni obbligatorie: $missing',
        );
      }

      final isMain = appliedCompanyId == referent.company.id;

      final appReferent = JobApplicationReferent(
        referentAffiliation:
            isMain ? ReferentAffiliation.main : ReferentAffiliation.client,
        referent: referent.referent,
      );

      await _jaRepository.addReferentToJobApplication(
        applicationId,
        appReferent,
      );

      _referentsNotifier.linkReferentToJobApplication(appReferent);

      final updateList =
          state.requireValue
              .where((el) => el.referent.id != referent.referent.id)
              .toList();

      state = AsyncData(updateList);

      return Success(data: true, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  ReferentRepository get _referentRepo => ref.read(referentRepositoryProvider);

  JobApplicationReferentsRepository get _jaRepository =>
      ref.read(jobApplicationReferentsRepositoryProvider);

  ReferentsNotifier get _referentsNotifier =>
      ref.read(referentsProvider.notifier);
}

final referentsSelectorProvider = AutoDisposeAsyncNotifierProvider<
  ReferentsSelectorNotifier,
  List<ReferentWithCompany>
>(ReferentsSelectorNotifier.new);
