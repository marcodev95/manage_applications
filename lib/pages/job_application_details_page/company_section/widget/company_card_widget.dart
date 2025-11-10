import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/provider/company_change_screen_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/select_company_page/select_company_page.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/are_job_application_id_and_company_id_present.dart';
import 'package:manage_applications/widgets/components/divider_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class CompanyCardWidget extends StatelessWidget {
  const CompanyCardWidget({
    super.key,
    required this.cardLabel,
    this.company,
    this.isMain = true,
  });

  final Company? company;
  final String cardLabel;
  final bool isMain;

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      externalPadding: EdgeInsets.zero,
      title: cardLabel,
      body: Padding(
        padding: const EdgeInsets.all(AppStyle.pad8),
        child:
            company?.id == null
                ? _EmptyCompanyLayout(isMain)
                : _CompanyDataLayout(company: company!, isMain: isMain),
      ),
    );
  }
}

class _EmptyCompanyLayout extends ConsumerWidget {
  const _EmptyCompanyLayout(this.isMainCompany);

  final bool isMainCompany;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive =
        isMainCompany
            ? ref.watch(isJobApplicationIdPresent)
            : ref.watch(areJobApplicationIdAndCompanyIdPresent);

    final companyScreen =
        isMainCompany
            ? CompanyScreen.mainCompanyForm
            : CompanyScreen.clientCompanyForm;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: TextButton.icon(
            icon: const Icon(Icons.add_business, color: Colors.blue),
            onPressed:
                isActive
                    ? () => ref
                        .read(companyChangeScreenProvider.notifier)
                        .goToCompanyForm(companyScreen)
                    : null,
            label: const Text(
              'Aggiunti azienda',
              style: TextStyle(
                color: Colors.blue,
                fontSize: AppStyle.tableTextFontSize,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        Flexible(
          child: TextButton.icon(
            icon: const Icon(
              Icons.format_list_bulleted_add,
              color: Colors.deepOrange,
            ),
            onPressed:
                isActive
                    ? () => _openSelectCompanyPage(context, isMainCompany)
                    : null,
            label: const Text(
              'Seleziona azienda',
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: AppStyle.tableTextFontSize,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.deepOrange),
            ),
          ),
        ),
      ],
    );
  }
}

class _CompanyDataLayout extends StatelessWidget {
  const _CompanyDataLayout({required this.company, required this.isMain});

  final Company company;
  final bool isMain;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8.0,
          children: [
            Icon(
              Icons.business,
              size: 28,
              color: isMain ? Colors.blueAccent : Colors.green,
            ),
            Text(
              company.name,
              style: const TextStyle(
                fontSize: AppStyle.headingFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const DividerWidget(height: 20),
        _CompanyInfoRow(
          Icons.location_city,
          '${company.address}, ${company.city}',
        ),
        _CompanyInfoRow(Icons.mail_outline, company.email),
        _CompanyInfoRow(Icons.phone, company.phoneNumber ?? '-'),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed:
                () => tryToLaunchUrl(context: context, link: company.website),
            icon: const Icon(Icons.language),
            label: const Text('Visita sito'),
          ),
        ),
      ],
    );
  }
}

class _CompanyInfoRow extends StatelessWidget {
  const _CompanyInfoRow(this.icon, this.value);

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        spacing: 8.0,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: AppStyle.tableTextFontSize),
            ),
          ),
        ],
      ),
    );
  }
}

void _openSelectCompanyPage(BuildContext context, bool isMain) {
  navigatorPush(context, SelectCompanyPage(isMainCompany: isMain));
}
