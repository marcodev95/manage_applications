import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_card.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_form.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/client_company/client_company_card.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/client_company/client_company_form.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_section.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/form/company_referent_form.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/provider/company_change_screen_provider.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:manage_applications/widgets/components/responsive_layout_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';


///
/// * Sistemare elenco aziende e referenti x renderlo uniforme allo stile generale
///

class CompanySection extends ConsumerWidget {
  const CompanySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.watch(
      companyChangeScreenProvider.select((value) => value.screen),
    );

    return SingleChildScrollView(
      primary: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Offstage(
            offstage: screen != CompanyScreen.initial,
            child: const Padding(
              padding: EdgeInsets.all(AppStyle.pad24),
              child: _ResponsiveSectionLayout(),
            ),
          ),
          Visibility(
            visible: screen == CompanyScreen.mainCompanyForm,
            child: const _CardCompanySections(
              AppliedCompanyForm(),
              'Dati azienda annuncio',
            ),
          ),
          Visibility(
            visible: screen == CompanyScreen.clientCompanyForm,
            child: const _CardCompanySections(
              ClientCompanyForm(),
              'Dati azienda cliente',
            ),
          ),
          Visibility(
            visible: screen == CompanyScreen.referentForm,
            child: const _CardCompanySections(
              CompanyReferentForm(),
              'Dettagli referente',
            ),
          ),
        ],
      ),
    );
  }
}

class _InitialSection extends StatelessWidget {
  const _InitialSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 30.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 40.0,
          children: [
            Expanded(child: AppliedCompanyCard()),
            Expanded(child: ClientCompanyCard()),
          ],
        ),
        CompanyReferentSection(),
      ],
    );
  }
}

class _ResponsiveSectionLayout extends StatelessWidget {
  const _ResponsiveSectionLayout();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutWidget(
      desktop: (_, __) => const _InitialSection(),
      compact:
          (_, __) => const Column(
            spacing: 30.0,
            children: [
              AppliedCompanyCard(),
              ClientCompanyCard(),
              CompanyReferentSection(),
            ],
          ),
    );
  }
}

class _CardCompanySections extends ConsumerWidget {
  const _CardCompanySections(this.body, this.titleCard);

  final Widget body;
  final String titleCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionWidget(
      title: titleCard,
      body: body,
      trailing: TextButtonWidget(
        onPressed:
            () => ref.read(companyChangeScreenProvider.notifier).goBack(),
        label: 'Indietro',
      ),
    );
  }
}
