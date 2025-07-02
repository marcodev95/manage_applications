import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/applied_company_section/applied_company_form_controller.dart';
import 'package:manage_applications/pages/job_applications_page/job_applications_table/job_applications_table_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/repository/company_repository.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class SelectCompanyPage extends StatelessWidget {
  const SelectCompanyPage({super.key, required this.onPressedSelectCompany});

  final void Function(Company) onPressedSelectCompany;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selezione l'azienda"),
        actions: const [ErrorsWidget()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppStyle.pad24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: _CompanyTable(onPressedSelectCompany),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyTable extends ConsumerWidget {
  const _CompanyTable(this.onPressedSelectCompany);

  final void Function(Company) onPressedSelectCompany;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenOnErrorWithoutSnackbar(
      provider: _filteredCompaniesProvider,
      context: context,
    );

    final asyncCompanies = ref.watch(_filteredCompaniesProvider);

    return asyncCompanies.when(
      data:
          (companies) => TableWidget(
            columns: const [
              DataColumn(label: Text("Nome")),
              DataColumn(label: Text("Indirizzo")),
              DataColumn(label: Text("")),
            ],
            dataRow: buildColoredRow(
              list: companies,
              cells:
                  (company, _) => [
                    DataCell(
                      SizedBox(
                        width: 150.0,
                        child: Text(
                          company.name,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text("${company.city}, ${company.address}")),
                    DataCell(
                      TextButton(
                        onPressed: () => onPressedSelectCompany(company),
                        child: Text('Associa'),
                      ),
                    ),
                  ],
            ),
          ),
      error:
          (_, __) => DataLoadErrorScreenWidget(
            onPressed: () => ref.invalidate(_fetchCompaniesProvider),
          ),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

final _fetchCompaniesProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.read(companyRepositoryProvider);

  return await repository.getAllCompaniesRows();
});

final _filteredCompaniesProvider = FutureProvider.autoDispose((ref) async {
  final lastCompanyId = ref.watch(appliedCompanyFormController).value?.id;

  final companiesList = await ref.watch(_fetchCompaniesProvider.future);

  return companiesList.where((c) => c.id != lastCompanyId).toList();
});