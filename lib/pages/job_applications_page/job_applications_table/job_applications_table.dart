import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_applications_page/job_applications_table/job_applications_table_barrel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/job_data/job_application_ui.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';
import 'package:manage_applications/widgets/components/paginator_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';
import 'package:manage_applications/widgets/empty_list_message_widget.dart';

class JobApplicationsTable extends ConsumerWidget {
  const JobApplicationsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenOnErrorWithoutSnackbar(
      provider: paginatorApplicationsUIProvider,
      context: context,
    );

    final paginatorAsync = ref.watch(paginatorApplicationsUIProvider);

    return paginatorAsync.when(
      skipLoadingOnReload: true,
      skipError: true, //Non funziona su errori del AsyncNotifier build
      data:
          (paginator) => Column(
            spacing: 30.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 400.0,
                child: JobApplicationsTableBody(paginator.items),
              ),
              PaginatorWidget(
                paginatorState: paginator,
                previousPage: () => _previousPage(ref),
                nextPage: () => _nextPage(ref),
              ),
            ],
          ),
      error: (_, __) {
        return DataLoadErrorScreenWidget(
          onPressed: () => ref.invalidate(paginatorApplicationsUIProvider),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void _previousPage(WidgetRef ref) =>
      ref.read(paginatorApplicationsUIProvider.notifier).goBack();

  void _nextPage(WidgetRef ref) =>
      ref.read(paginatorApplicationsUIProvider.notifier).nextPage();
}

class JobApplicationsTableBody extends ConsumerWidget {
  const JobApplicationsTableBody(this.applicationsUI, {super.key});

  final List<JobApplicationUi> applicationsUI;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (applicationsUI.isEmpty) {
      return EmptyListMessageWidget('Nessuna candidatura presente');
    }

    return TableWidget(
      columns: [
        dataColumnWidget('Posizione'),
        dataColumnWidget('Azienda'),
        dataColumnWidget('Data candidatura'),
        dataColumnWidget('Stato'),
        dataColumnWidget('Azioni'),
      ],
      dataRow: buildColoredRow<JobApplicationUi>(
        list: applicationsUI,
        cells:
            (jobData, _) => [
              DataCell(
                SizedBox(
                  width: 250.0,
                  child: Tooltip(
                    message: jobData.position,
                    child: TextOverflowEllipsisWidget(
                      jobData.position,
                      fontSize: AppStyle.tableTextFontSize,
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 140.0,
                  child: Tooltip(
                    message: jobData.companyRef?.name ?? '',
                    child: TextOverflowEllipsisWidget(
                      jobData.companyRef?.name ?? '',
                      fontSize: AppStyle.tableTextFontSize,
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 142.0,
                  child: TextOverflowEllipsisWidget(
                    uiFormat.format(jobData.applyDate),
                    fontSize: AppStyle.tableTextFontSize,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 120.0,
                  child: JobApplicationStatusChip(
                    applicationStatus: jobData.applicationStatus,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 160.0,
                  child: TableButtonsWidget(
                    buttons: [
                      JobApplicationDetailsButton(id: jobData.id!),
                      IconButton(
                        icon: Icon(Icons.link, color: Colors.blue),
                        onPressed:
                            () async => await tryToLaunchUrl(
                              context: context,
                              link: jobData.link,
                            ),
                      ),
                      JobApplicationRemoveButtonWidget(jobData.id!),
                    ],
                  ),
                ),
              ),
            ],
      ),
    );
  }
}
