import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/client_company/client_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/provider/company_change_screen_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/widget/company_card_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/are_job_application_id_and_company_id_present.dart';

class ClientCompanyCard extends ConsumerWidget {
  const ClientCompanyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CompanyCardWidget(
      trailing: CompanyCardTrailing(
        selectCompanyOperation:
            (selectedCompany) => ref
                .read(clientCompanyFormProvider.notifier)
                .selectCompany(selectedCompany),
        goToForm:
            () =>
                ref
                    .read(companyChangeScreenProvider.notifier)
                    .goToClientCompanyForm(),
        isActive: ref.watch(areJobApplicationIdAndCompanyIdPresent),
      ),
      externalPadding: const EdgeInsets.symmetric(horizontal: 24),
      cardLabel: 'Azienda cliente',
      company: ref
          .watch(clientCompanyFormProvider)
          .whenOrNull(data: (data) => data),
      isMain: false,
    );
  }
}
