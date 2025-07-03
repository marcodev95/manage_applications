import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/client_company/client_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/provider/company_change_screen_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/widget/company_form_widget.dart';

class ClientCompanyForm extends ConsumerWidget {
  const ClientCompanyForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CompanyFormWidget(
      submit: (c, f) async {
        if (f.currentState!.validate()) {
          final submit = await ref
              .read(clientCompanyFormProvider.notifier)
              .addClientCompany(c);

          if (!context.mounted) return;

          submit.handleResult(context: context, ref: ref);

          if (submit.isSuccess) {
            ref.read(companyChangeScreenProvider.notifier).goBack();
          }
        }
      },
    );
  }
}
