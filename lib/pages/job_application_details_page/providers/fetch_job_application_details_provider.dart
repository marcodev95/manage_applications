import 'package:manage_applications/models/job_application_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/repository/job_application_details_repository.dart';

final jobApplicationId = StateProvider<int>((_) => 0);

final fetchJobApplicationDetailsProvider =
    FutureProvider.autoDispose<JobApplicationDetails>((ref) async {
      final id = ref.watch(jobApplicationId);
      final repository = ref.read(jobApplicationDetailsRepositoryProvider);

      if (id == 0) return JobApplicationDetails.defaultValue();

      return await repository.getJobApplicationDetails(jobDataId: id);
    });
