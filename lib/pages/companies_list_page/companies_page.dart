import 'package:flutter/services.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/company_details_page.dart';
import 'package:manage_applications/pages/job_applications_page/job_applications_table/job_applications_table_barrel.dart';
import 'package:manage_applications/providers/companies_paginator_notifier.dart';
import 'package:manage_applications/widgets/components/header_card_widget.dart';
import 'package:manage_applications/widgets/components/paginator_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class CompaniesPage extends ConsumerWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginator = ref.watch(asyncCompaniesProvider);

    ref.listenOnErrorWithSnackbar(
      provider: asyncCompaniesProvider,
      context: context,
    );

    return paginator.when(
      skipLoadingOnReload: true,
      skipError: true,
      data:
          (paginator) => Padding(
            padding: const EdgeInsets.all(AppStyle.pad24),
            child: HeaderCardWidget(
              titleLabel: 'Lista aziende',
              crossAxisAlignment: CrossAxisAlignment.stretch,
              cardBody: Padding(
                padding: EdgeInsets.symmetric(vertical: AppStyle.pad16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 490,
                      child: CompaniesList(paginator.items),
                    ),

                    PaginatorWidget(
                      paginatorState: paginator,
                      previousPage: () => _previousPage(ref),
                      nextPage: () => _nextPage(ref),
                    ),
                  ],
                ),
              ),
            ),
          ),
      error: (e, stackTrace) {
        return DataLoadErrorScreenWidget(
          onPressed: () => ref.invalidate(asyncCompaniesProvider),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void _previousPage(WidgetRef ref) =>
      ref.read(asyncCompaniesProvider.notifier).goBack();
  void _nextPage(WidgetRef ref) =>
      ref.read(asyncCompaniesProvider.notifier).nextPage();
}

class CompaniesList extends ConsumerWidget {
  const CompaniesList(this.companies, {super.key});

  final List<Company> companies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TableWidget(
      columns: [
        dataColumnWidget('Nome'),
        dataColumnWidget('Città'),
        dataColumnWidget('Email'),
        dataColumnWidget('Azioni'),
      ],
      dataRow: buildColoredRow(
        list: companies,
        cells:
            (c, index) => [
              DataCell(
                SizedBox(
                  width: 250.0,
                  child: TextOverflowEllipsisWidget(
                    c.name,
                    fontSize: AppStyle.tableTextFontSize,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 150.0,
                  child: TextOverflowEllipsisWidget(
                    c.city,
                    fontSize: AppStyle.tableTextFontSize,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 150.0,
                  child: InkWell(
                    onTap: () {
                      if (c.email.isNotEmpty) {
                        Clipboard.setData(ClipboardData(text: c.email));
                        showSuccessSnackBar(
                          message: 'Testo copiato negli appunti',
                          context: context,
                        );
                      }
                    },
                    child: Text(
                      c.email,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppStyle.tableTextFontSize,
                        color: Colors.lightBlueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.language,
                        color: index.isOdd ? Colors.white70 : Colors.blueAccent,
                      ),
                      tooltip: c.website,
                      onPressed: () async {
                        await tryToLaunchUrl(context: context, link: c.website);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.info,
                        color: index.isOdd ? Colors.white70 : Colors.blueAccent,
                      ),
                      onPressed: () {
                        navigatorPush(
                          context,
                          CompanyDetailsPage(),
                          RouteSettings(arguments: c.id),
                        );
                      },
                      tooltip: 'Dettagli',
                    ),
                  ],
                ),
              ),
            ],
      ),
    );
  }
}
