import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/provider/company_change_screen_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/widget/company_card_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/are_job_application_id_and_company_id_present.dart';

class AppliedCompanyCard extends ConsumerWidget {
  const AppliedCompanyCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CompanyCardWidget(
      trailing: CompanyCardTrailing(
        selectCompanyOperation:
            (selectedCompany) => ref
                .read(appliedCompanyFormProvider.notifier)
                .selectCompany(selectedCompany),
        goToForm:
            () =>
                ref
                    .read(companyChangeScreenProvider.notifier)
                    .goToMainCompanyForm(),
        isActive: ref.watch(isJobApplicationIdPresent),
      ),
      cardLabel: 'Azienda annuncio',
      company: ref
          .watch(appliedCompanyFormProvider)
          .whenOrNull(data: (data) => data),
    );
  }
}
