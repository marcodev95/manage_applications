import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/client_company/client_company_form_notifier.dart';
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
      final workPlace = widget.notifier.value;

      if (workPlace == WorkPlace.azienda) {
        ref.read(appliedCompanyFormProvider).whenData((value) {
          widget.controller.text = formatAddress(value);
        });
      } else if (workPlace == WorkPlace.cliente) {
        ref.read(clientCompanyFormProvider).whenData((value) {
          widget.controller.text = formatAddress(value);
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

  String formatAddress(Company company) =>
      '${company.address} - ${company.city}';
}
