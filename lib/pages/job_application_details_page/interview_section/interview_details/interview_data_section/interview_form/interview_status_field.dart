import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';

class InterviewStatusField extends ConsumerWidget {
  const InterviewStatusField({
    super.key,
    this.routeID,
    required this.callback,
  });

  final int? routeID;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      interviewFormProvider(
        routeID,
      ).select((value) => value.whenOrNull(data: (data) => data.status)),
    );

    if (status == null) return SizedBox();

    return Expanded(
      child: ReadOnlyTextFormField(
        initialValue: status.displayName,
        label: 'Stato del colloquio(*)',
        suffixIcon: Tooltip(
          message: 'Modifica stato colloquio',
          child: IconButton(
            onPressed: callback,
            icon: const Icon(Icons.edit, color: Colors.amber),
          ),
        ),
      ),
    );
  }
}
