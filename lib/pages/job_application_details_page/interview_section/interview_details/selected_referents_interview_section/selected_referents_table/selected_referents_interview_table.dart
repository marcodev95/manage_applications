import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_barrel.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_table/selected_referents_interview_notifier.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class SelectedReferentsInterviewTable extends ConsumerStatefulWidget {
  const SelectedReferentsInterviewTable({super.key});

  @override
  ConsumerState<SelectedReferentsInterviewTable> createState() =>
      SelectedReferentsInterviewTableState();
}

class SelectedReferentsInterviewTableState
    extends ConsumerState<SelectedReferentsInterviewTable> {
  @override
  Widget build(BuildContext context) {
    final selectedReferentsAsync = ref.watch(
      selectedReferentsForInterviewProvider(getRouteArg<int?>(context)),
    );

    return selectedReferentsAsync.when(
      skipError: true,
      skipLoadingOnReload: true,
      data: (selectedReferents) {
        return TableWidget(
          columns: [
            dataColumnWidget('Nome'),
            dataColumnWidget('Ruolo'),
            dataColumnWidget('Email'),
            dataColumnWidget('Rimuovi'),
          ],
          dataRow: buildColoredRow(
            list: selectedReferents,
            cells:
                (sr, _) => [
                  DataCell(CompanyReferentBadge(sr.referent)),
                  DataCell(
                    Text(
                      sr.referent.referent.role.displayName,
                      style: const TextStyle(
                        fontSize: AppStyle.tableTextFontSize,
                      ),
                    ),
                  ),
                  DataCell(
                    TextOverflowEllipsisWidget(
                      sr.referent.referent.email,
                      fontSize: AppStyle.tableTextFontSize,
                    ),
                  ),
                  DataCell(
                    RemoveButtonWidget(
                      label: 'Rimuovi',
                      onPressed: () {
                        ref
                            .read(
                              selectedReferentsForInterviewProvider(
                                getRouteArg<int?>(context),
                              ).notifier,
                            )
                            .removeReferent(sr.id);
                      },
                    ),
                  ),
                ],
          ),
        );
      },
      error:
          (_, __) => DataLoadErrorScreenWidget(
            onPressed:
                () => ref.invalidate(selectedReferentsForInterviewProvider),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
