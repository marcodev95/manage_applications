import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:flutter/material.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';

class InterviewPlaceField extends ConsumerStatefulWidget {
  const InterviewPlaceField({
    super.key,
    required this.controller,
    required this.notifier,
  });

  final TextEditingController controller;
  final ValueNotifier<InterviewsFormat> notifier;

  @override
  ConsumerState<InterviewPlaceField> createState() =>
      _InterviewPlaceFieldState();
}

class _InterviewPlaceFieldState extends ConsumerState<InterviewPlaceField> {
  late final VoidCallback _notifierListener;

  @override
  void initState() {
    super.initState();

    _notifierListener = () {
      final format = widget.notifier.value;
      if (format == InterviewsFormat.presenza) {
        final company = ref.read(appliedCompanyFormProvider).value;
        widget.controller.text = '${company?.address} - ${company?.city}';
      } else {
        widget.controller.clear();
      }
    };

    widget.notifier.addListener(_notifierListener);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_notifierListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<InterviewsFormat>(
      valueListenable: widget.notifier,
      builder: (_, format, __) {
        final isOnline = format == InterviewsFormat.online;
        final isPhone = format == InterviewsFormat.telefono;
        final isReadOnly = format == InterviewsFormat.presenza || format == InterviewsFormat.altro;
        final fieldLabel =
            isOnline ? 'Piattaforma del colloquio' : 'Luogo del colloquio';

        if (isPhone) {
          return const SizedBox.shrink();
        }

        return FormFieldWidget(
          controller: widget.controller,
          label: fieldLabel,
          readOnly: isReadOnly,
          validator: (v) => baseValidator(v, fieldLabel),
        );
      },
    );
  }
}
