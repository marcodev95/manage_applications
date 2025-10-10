import 'package:manage_applications/models/interview/interview_details.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/repository/interview_repository.dart';
import 'package:riverpod/riverpod.dart';

final getInterviewDetailsProvider = FutureProvider.autoDispose
    .family<InterviewDetails, int>((ref, int id) async {
      final repository = ref.read(interviewRepository);

      final result = await repository.getInterviewDetails(id);

      return result.data;
    });
