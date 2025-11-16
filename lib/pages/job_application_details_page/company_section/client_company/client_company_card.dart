import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/client_company/client_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/widget/company_card_widget.dart';

class ClientCompanyCard extends ConsumerWidget {
  const ClientCompanyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CompanyCardWidget(
      cardLabel: 'Azienda cliente',
      company: ref
          .watch(clientCompanyFormProvider)
          .whenOrNull(data: (data) => data),
      isMain: false,
    );
  }
}
