import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/referent/referent_with_company.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/referent_selection/referents_selector_notifier.dart';
import 'package:manage_applications/widgets/components/button/associate_button_widget.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_panel_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class ReferentSelectionPage extends StatelessWidget {
  const ReferentSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista referenti'),
        actions: [ErrorsPanelButtonWidget()],
      ),
      body: const AppCard(
        child: SizedBox.expand(child: SelectTableForReferents()),
      ),
    );
  }
}

class SelectTableForReferents extends ConsumerWidget {
  const SelectTableForReferents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenOnErrorWithoutSnackbar(
      provider: referentsSelectorProvider,
      context: context,
    );

    final allReferentsAsync = ref.watch(referentsSelectorProvider);

    return allReferentsAsync.when(
      skipError: true,
      skipLoadingOnReload: true,
      data:
          (data) => TableWidget(
            columns: [
              dataColumnWidget('Nome'),
              dataColumnWidget('Ruolo'),
              dataColumnWidget('Email'),
              dataColumnWidget('Azienda'),
              dataColumnWidget('Azioni'),
            ],
            dataRow: buildColoredRow(
              list: data,
              cells:
                  (r, _) => [
                    DataCell(
                      SizedBox(
                        width: 180.0,
                        child: Tooltip(
                          message: r.referent.name,
                          child: Text(
                            r.referent.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: AppStyle.tableTextFontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 100.0,
                        child: Tooltip(
                          message: r.referent.role.displayName,
                          child: Text(
                            r.referent.role.displayName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                    DataCell(
                      SizedBox(
                        width: 150.0,
                        child: Tooltip(
                          message: r.referent.email,
                          child: Text(
                            r.referent.email,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 150.0,
                        child: Tooltip(
                          message: r.company.name,
                          child: Text(
                            r.company.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        spacing: 20.0,
                        children: [
                          AssociateButtonWidget(
                            () => _associate(ref, context, r),
                          ),
                          RemoveButtonWidget(onPressed: () {}),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
      error:
          (_, __) => DataLoadErrorScreenWidget(
            onPressed: () => ref.invalidate(referentsSelectorProvider),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _associate(
    WidgetRef ref,
    BuildContext context,
    ReferentWithCompany referent,
  ) async {
    final notifier = ref.read(referentsSelectorProvider.notifier);
    final result = await notifier.associate(referent);

    if (!context.mounted) return;

    result.handleErrorResult(context: context, ref: ref);
  }
}
