import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/applied_company_section/applied_company_form_controller.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/client_company_section/client_company_form_controller.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/contract_form/contract_form_utlity.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';

class WorkPlaceField extends ConsumerStatefulWidget {
  const WorkPlaceField({
    super.key,
    required this.controller,
    required this.notifier,
  });

  final TextEditingController controller;
  final ValueNotifier<WorkPlace> notifier;

  @override
  ConsumerState<WorkPlaceField> createState() => _WorkPlaceFieldState();
}

class _WorkPlaceFieldState extends ConsumerState<WorkPlaceField> {
  late final VoidCallback _notifierListener;

  @override
  void initState() {
    super.initState();

    _notifierListener = () {
      if (widget.notifier.value == WorkPlace.azienda) {
        ref.read(appliedCompanyFormController).whenData((value) {
          widget.controller.text = '${value.address} - ${value.city}';
        });
      } else if (widget.notifier.value == WorkPlace.cliente) {
        ref.read(clientCompanyFormController).whenData((value) {
          widget.controller.text = '${value.address} - ${value.city}';
        });
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
    return ValueListenableBuilder<WorkPlace>(
      valueListenable: widget.notifier,
      builder: (_, workPlace, __) {
        final isAltro = workPlace == WorkPlace.altro;

        return FormFieldWidget(
          controller: widget.controller,
          label: 'Luogo di lavoro',
          readOnly: !isAltro,
          validator:
              isAltro ? (v) => baseValidator(v, 'Luogo di lavoro') : null,
        );
      },
    );
  }
}
