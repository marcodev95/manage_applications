import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/provider/company_change_screen_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_table.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/are_job_application_id_and_company_id_present.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyReferentSection extends StatelessWidget {
  const CompanyReferentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionWidget(
      externalPadding: EdgeInsets.symmetric(
        vertical: AppStyle.pad16,
        horizontal: AppStyle.pad24,
      ),
      title: "Lista referenti",
      trailing: _CompanyReferentTrailing(),
      body: SizedBox(
        height: 546.0,
        child: SingleChildScrollView(
          primary: false,
          child: CompanyReferentTable(),
        ),
      ),
    );
  }
}

class _CompanyReferentTrailing extends ConsumerWidget {
  const _CompanyReferentTrailing();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(areJobApplicationIdAndCompanyIdPresent);

    return TextButtonWidget(
      onPressed:
          isActive
              ? () =>
                  ref
                      .read(companyChangeScreenProvider.notifier)
                      .goToReferentCompanyForm()
              : () {},
      label: 'Aggiungi referente',
      isEnable: isActive,
    );
  }
}
