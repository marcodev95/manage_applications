import 'package:manage_applications/api/get_job_data_details.dart';
import 'package:manage_applications/models/job_application_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//https://stackoverflow.com/questions/75062025/flutter-riverpod-futureprovider

final jobApplicationId = StateProvider<int>((_) => 0);

final fetchJobApplicationDetailsProvider =
    FutureProvider.autoDispose<JobApplicationDetails>((ref) async {
      final id = ref.watch(jobApplicationId);

      if (id == 0) return JobApplicationDetails.defaultValue();

      return await getJobApplicationDetails(jobDataId: id);
    });
