import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/referent/referent_details.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';
import 'package:manage_applications/repository/referent_repository.dart';

final referentDetailsProvider = FutureProvider.autoDispose
    .family<ReferentDetails, int>((ref, int referentId) async {
      final repository = ref.read(referentRepositoryProvider);

      final applicationId = ref.read(jobApplicationProvider).value?.id;

      if (applicationId == null) {
        throw MissingInformationError(error: {'missing': 'applicationId'});
      }

      return await repository.getReferentDetails(applicationId, referentId);
    });
