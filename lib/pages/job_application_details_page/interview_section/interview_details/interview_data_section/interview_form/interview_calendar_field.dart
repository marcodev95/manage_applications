import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_notifier.dart';
import 'package:manage_applications/widgets/components/calendar_widget.dart';

class InterviewCalendarField extends ConsumerWidget {
  const InterviewCalendarField(this.notifier, this.routeArg, {super.key});

  final ValueNotifier<DateTime> notifier;
  final int? routeArg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInterviewIdNull = ref.watch(
      interviewFormProvider(routeArg).select(
        (value) => value.whenOrNull(data: (data) => data.id != null) ?? false,
      ),
    );

    return AbsorbPointer(
      absorbing: isInterviewIdNull,
      child: CalendarWidget(label: 'Data colloquio', selectedDate: notifier),
    );
  }
}
