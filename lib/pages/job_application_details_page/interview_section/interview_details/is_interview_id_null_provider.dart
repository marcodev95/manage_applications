import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_controller.dart';

final isInterviewIdNullProvider = Provider.autoDispose.family<bool, int?>(
  (ref, id) => ref.watch(
    interviewFormController(
      id,
    ).select((value) => value.hasValue && value.value?.id == null),
  ),
);
