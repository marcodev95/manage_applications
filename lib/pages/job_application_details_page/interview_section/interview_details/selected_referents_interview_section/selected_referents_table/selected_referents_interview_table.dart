import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_badge.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_table/selected_referents_interview_notifier.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

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
                (referent, _) => [
                  DataCell(CompanyReferentBadge(referent.referent)),
                  DataCell(
                    Text(
                      referent.referent.role.displaName,
                      style: TextStyle(fontSize: AppStyle.tableTextFontSize),
                    ),
                  ),
                  DataCell(
                    TextOverflowEllipsisWidget(
                      referent.referent.email,
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
                            .removeReferent(referent.id);
                      },
                    ),
                  ),
                ],
          ),
        );
      },
      error: (error, stackTrace) => Text('Eventuale reload ? '),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}