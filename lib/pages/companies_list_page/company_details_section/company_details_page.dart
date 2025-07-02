import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/company_details_form/company_details_form.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/delete_company_button.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/providers/get_company_details_provider.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_panel_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/applications_related_client_company_section/applications_related_client_company_section.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/applications_related_main_company_section/applications_related_main_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class CompanyDetailsPage extends ConsumerWidget {
  const CompanyDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeID = getRouteArg<int?>(context);
    ref.listenOnErrorWithoutSnackbar(
      provider: getCompanyDetailsProvider(routeID),
      context: context,
    );

    final companyDetailsAsync = ref.watch(getCompanyDetailsProvider(routeID));

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dettagli azienda'),
          actions: const [
            DeleteCompanyButton(),
            SizedBox(width: 20.0),
            ErrorsPanelButtonWidget (),
          ],
          bottom: TabBar(
            onTap: (int index) {
              ref.read(_currentIndexProvider.notifier).state = index;
            },
            tabs: _tabs,
          ),
        ),
        body: companyDetailsAsync.when(
          data:
              (details) => Padding(
                padding: const EdgeInsets.all(AppStyle.pad24),
                child: _PageTabsWidget(details),
              ),
          error: (_, __) {
            return DataLoadErrorScreenWidget(
              onPressed: () => ref.invalidate(getCompanyDetailsProvider),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  List<Tab> get _tabs => [
    Tab(text: 'Dettagli azienda'),
    Tab(text: 'Lista candidature come azienda principale'),
    Tab(text: 'Lista candidature come azienda cliente'),
  ];
}

class _PageTabsWidget extends ConsumerWidget {
  const _PageTabsWidget(this.details);

  final Company details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IndexedStack(
      index: ref.watch(_currentIndexProvider),
      children: [
        AppCard(child: CompanyDetailsForm(details)),
        SizedBox.expand(
          child: AppCard(
            child: SingleChildScrollView(
              child: ApplicationsRelatedMainCompany(details.id!),
            ),
          ),
        ),

        SizedBox.expand(
          child: AppCard(
            child: SingleChildScrollView(
              child: ApplicationsRelatedClientCompanySectionSection(
                details.id!,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final _currentIndexProvider = StateProvider.autoDispose((_) => 0);
