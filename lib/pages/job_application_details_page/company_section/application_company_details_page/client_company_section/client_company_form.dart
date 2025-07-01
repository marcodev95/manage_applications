import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/client_company_section/client_company_form_controller.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/company_form_widget.dart';

class ClientCompanyForm extends ConsumerWidget {
  const ClientCompanyForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CompanyFormWidget(
      submit: (c, f) async {
        if (f.currentState!.validate()) {
          final submit = await ref
              .read(clientCompanyFormController.notifier)
              .addClientCompany(c);

          if (!context.mounted) return;

          submit.handleResult(context: context, ref: ref);
        }
      },
    );
  }
}
