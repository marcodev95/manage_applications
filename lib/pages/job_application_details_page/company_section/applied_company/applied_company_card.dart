import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/widget/company_card_widget.dart';

class AppliedCompanyCard extends ConsumerWidget {
  const AppliedCompanyCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CompanyCardWidget(      
      cardLabel: 'Azienda annuncio',
      company: ref
          .watch(appliedCompanyFormProvider)
          .whenOrNull(data: (data) => data),
    );
  }
}
