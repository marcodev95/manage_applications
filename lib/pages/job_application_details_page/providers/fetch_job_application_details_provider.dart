import 'package:manage_applications/models/job_application_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/repository/job_application_details_repository.dart';

final jobApplicationIdProvider = StateProvider<int?>((_) => null);

final fetchJobApplicationDetailsProvider =
    FutureProvider.autoDispose<JobApplicationDetails>((ref) async {
      final repository = ref.read(jobApplicationDetailsRepositoryProvider);
      final id = ref.watch(jobApplicationIdProvider);

      if (id == null) return JobApplicationDetails.defaultValue();

      return await repository.getJobApplicationDetails(id);
    });
