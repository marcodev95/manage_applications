import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_details.dart';
import 'package:manage_applications/repository/referents_interview_repository.dart';
import 'package:riverpod/riverpod.dart';

final getInterviewDetailsProvider = FutureProvider.autoDispose
    .family<InterviewDetails, int>((ref, int id) async {
      final repository = ref.read(referentsInterviewRepository);

      final result = await repository.getInterviewDetails(id);

      return result.data;
    });
