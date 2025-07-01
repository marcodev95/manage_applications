import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/applied_company_section/applied_company_form.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/client_company_section/client_company_form.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/form/company_referent_form.dart';

class ApplicationCompanyDetailsPage extends ConsumerWidget {
  const ApplicationCompanyDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [ErrorsWidget()],
          title: const Text('Dettagli azienda'),
          bottom: TabBar(
            onTap: (int? index) {
              if (index != null) {
                ref.read(applicationCompanyPageIndex.notifier).state = index;
              }
            },
            tabs: _tabs,
          ),
        ),
        body: _PageTabsWidget(),
      ),
    );
  }

  List<Tab> get _tabs => [
    Tab(text: 'Dettagli azienda a cui mi sono candidato'),
    Tab(text: 'Dettagli azienda a cliente'),
    Tab(text: 'Lista dei referenti delle aziende'),
  ];
}

class _PageTabsWidget extends ConsumerWidget {
  const _PageTabsWidget();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IndexedStack(
      index: ref.watch(applicationCompanyPageIndex),
      children: [
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(AppStyle.pad24),
            child: AppliedCompanyForm()
          ),
        ),
        ClientCompanyForm(),
        CompanyReferentForm(),
      ],
    );
  }
}

final applicationCompanyPageIndex = StateProvider.autoDispose((_) => 0);
