import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_barrel.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_referents_table.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_table/selected_referents_interview_notifier.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';

class SelectedReferentsInterviewTable extends ConsumerWidget {
  const SelectedReferentsInterviewTable(this.routeID, {super.key});

  final int? routeID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReferentsAsync = ref.watch(
      selectedReferentsForInterviewProvider(routeID),
    );

    return InterviewReferentsTable(
      allReferents: selectedReferentsAsync,
      columns: [
        dataColumnWidget('Nome'),
        dataColumnWidget('Ruolo'),
        dataColumnWidget('Email'),
        dataColumnWidget('Rimuovi'),
      ],
      dataCellBuilder: (sr, _) {
        final referent = sr.referentWithAffiliation.referent;
        return [
          DataCell(CompanyReferentBadge(sr.referentWithAffiliation)),
          DataCell(
            Text(
              referent.role.displayName,
              style: const TextStyle(fontSize: AppStyle.tableTextFontSize),
            ),
          ),
          DataCell(
            TextOverflowEllipsisWidget(
              referent.email,
              fontSize: AppStyle.tableTextFontSize,
            ),
          ),
          DataCell(
            RemoveButtonWidget(
              label: 'Rimuovi',
              onPressed: () {
                final notifier = ref.read(
                  selectedReferentsForInterviewProvider(routeID).notifier,
                );
                notifier.removeReferent(sr.id);
              },
            ),
          ),
        ];
      },
      invalidate: () => ref.invalidate(selectedReferentsForInterviewProvider),
    );
  }
}
