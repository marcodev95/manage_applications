import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form/interview_form_field_barrel.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';

class InterviewStatusField extends ConsumerWidget {
  const InterviewStatusField({
    super.key,
    required this.callback,
    this.routeID,
  });

  final VoidCallback callback;
  final int? routeID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      interviewFormProvider(
        routeID,
      ).select((value) => value.whenOrNull(data: (data) => data.status)),
    );

    final interviewId = ref.watch(
      interviewFormProvider(
        routeID,
      ).select((value) => value.whenOrNull(data: (data) => data.id)),
    );

    final isIdNull = interviewId == null;
    final iconColor = isIdNull ? Colors.grey : Colors.amber;
    final onPressed = isIdNull ? null : callback;
    final messageTip =
        isIdNull
            ? 'Salva prima il colloquio per modificare lo stato'
            : 'Modifica stato colloquio';

    if (status == null) return SizedBox();

    return Expanded(
      child: ReadOnlyTextFormField(
        controller: TextEditingController(text: status.displayName),
        label: 'Stato del colloquio(*)',
        suffixIcon: Tooltip(
          message: messageTip,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.edit, color: iconColor),
          ),
        ),
      ),
    );
  }
} 

