import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/applied_company_section/applied_company_form_controller.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/company_form_widget.dart';

class AppliedCompanyForm extends ConsumerWidget {
  const AppliedCompanyForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CompanyFormWidget(
      company: ref.read(appliedCompanyFormController).value,
      submit: (c, f) async {
        if (f.currentState!.validate()) {
          final notifier = ref.read(appliedCompanyFormController.notifier);
          
          final submit = await notifier.addCompany(c);

          if (!context.mounted) return;

          submit.handleResult(context: context, ref: ref);
        }
      },
    );
  }
}
