import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/widgets/components/button/associate_button_widget.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_panel_button_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/repository/company_repository.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class SelectCompanyPage extends StatelessWidget {
  const SelectCompanyPage({super.key, required this.onPressedSelectCompany});

  final void Function(Company) onPressedSelectCompany;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selezione l'azienda"),
        actions: const [ErrorsPanelButtonWidget ()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppStyle.pad24),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: double.infinity,
                ),
                child: _CompanyTable(onPressedSelectCompany),
              ),
            );
          },
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
          (companies) => AppCard(
            child: TableWidget(
              columns: [
                dataColumnWidget('Nome'),
                dataColumnWidget('Indirizzo'),
                dataColumnWidget('Associa'),
              ],
              dataRow: buildColoredRow(
                list: companies,
                cells:
                    (company, index) => [
                      DataCell(
                        SizedBox(
                          width: 150.0,
                          child: Text(
                            company.name,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: AppStyle.tableTextFontSize,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          "${company.city}, ${company.address}",
                          style: TextStyle(
                            fontSize: AppStyle.tableTextFontSize,
                          ),
                        ),
                      ),
                      DataCell(
                        AssociateButtonWidget(
                          () => onPressedSelectCompany(company),
                          color: index.isOdd ? Colors.white : Colors.blue,
                        ),
                      ),
                    ],
              ),
            ),
          ),

      error:
          (_, __) => DataLoadErrorScreenWidget(
            onPressed: () => ref.invalidate(_fetchCompaniesProvider),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

final _fetchCompaniesProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.read(companyRepositoryProvider);

  return await repository.getAllCompaniesRows();
});

final _filteredCompaniesProvider = FutureProvider.autoDispose((ref) async {
  final lastCompanyId = ref.watch(appliedCompanyFormProvider).value?.id;

  final companiesList = await ref.watch(_fetchCompaniesProvider.future);

  return companiesList.where((c) => c.id != lastCompanyId).toList();
});
