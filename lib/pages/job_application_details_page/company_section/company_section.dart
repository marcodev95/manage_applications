import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/applied_company_section/applied_company_form.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/client_company_section/client_company_form.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/client_company/client_company_card.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_change_screen_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/form/company_referent_form.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_section.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_card.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';

class CompanySection extends ConsumerWidget {
  const CompanySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen =
        ref.watch(companyChangeScreenProvider).screen as CompanyScreen;

    return LayoutBuilder(
      builder: (_, constraints) {
        return SingleChildScrollView(
          primary: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Offstage(
                  offstage: screen != CompanyScreen.initial,
                  child: _InitialSection(),
                ),
                Visibility(
                  visible: screen == CompanyScreen.mainCompanyForm,
                  child: _CardCompanySections(
                    AppliedCompanyForm(),
                    'Dati azienda annuncio',
                  ),
                ),
                Visibility(
                  visible: screen == CompanyScreen.clientCompanyForm,
                  child: _CardCompanySections(
                    ClientCompanyForm(),
                    'Dati azienda cliente',
                  ),
                ),
                Visibility(
                  visible: screen == CompanyScreen.referentForm,
                  child: _CardCompanySections(
                    CompanyReferentForm(),
                    'Dettagli referente',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InitialSection extends StatelessWidget {
  const _InitialSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 750,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [AppliedCompanyCard(), ClientCompanyCard()],
            ),
          ),
          Expanded(flex: 2, child: CompanyReferentSection()),
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
