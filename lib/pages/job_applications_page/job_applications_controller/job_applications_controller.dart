/* import 'dart:async';

import 'package:manage_applications/providers/async_job_applications_notifier.dart';
import 'package:manage_applications/repository/job_data_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobApplicationsController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> deleteJobApplication({required int id}) async {
    final repository = ref.read(jobDataRepositoryProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      //await repository.deleteJobData(idJobData: id);
      ref
          .read(asyncJobApplicationsProvider.notifier)
          .deleteJobApplication(id: id);
    });
  }
}

final jobApplicationsController =
    AutoDisposeAsyncNotifierProvider<JobApplicationsController, void>(
  () => JobApplicationsController(),
);
 */