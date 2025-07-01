import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/client_company_section/client_company_form_controller.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_card/company_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_change_screen_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/select_company_page/select_company_page.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/are_job_application_id_and_company_id_present.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class ClientCompanyCard extends ConsumerWidget {
  const ClientCompanyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref
        .watch(clientCompanyFormController)
        .whenOrNull(data: (data) => data);

    return CompanyCardWidget(
      trailing: _ClientCompanyCardTrailing(),
      externalPadding: const EdgeInsets.symmetric(horizontal: 24),
      cardLabel: 'Azienda cliente',
      company: company,
      isMain: false,
    );
  }
}

class _ClientCompanyCardTrailing extends ConsumerWidget {
  const _ClientCompanyCardTrailing();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(areJobApplicationIdAndCompanyIdPresent);

    return isActive
        ? Wrap(
          spacing: 10,
          children: [
            TextButtonWidget(
              onPressed:
                  () => navigatorPush(
                    context,
                    SelectCompanyPage(
                      onPressedSelectCompany: (selectedCompany) async {
                        final result = await ref
                            .read(clientCompanyFormController.notifier)
                            .selectCompany(selectedCompany);

                        if (!context.mounted) return;

                        result.handleResult(context: context, ref: ref);

                        if (result.isSuccess) Navigator.pop(context);
                      },
                    ),
                  ),

              label: 'Seleziona azienda',
            ),
            TextButtonWidget(
              onPressed:
                  () =>
                      ref
                          .read(companyChangeScreenProvider.notifier)
                          .goToClientCompanyForm(),
              label: 'Aggiungi azienda',
            ),
          ],
        )
        : const SizedBox();
  }
}
