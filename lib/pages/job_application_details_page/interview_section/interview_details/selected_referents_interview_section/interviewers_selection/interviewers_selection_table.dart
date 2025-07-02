import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_badge.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/is_interview_id_null_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/interviewers_selection/interviewers_selection_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_table/selected_referents_interview_notifier.dart';
import 'package:manage_applications/widgets/components/button/associate_button_widget.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewersSelectionTable extends ConsumerWidget {
  const InterviewersSelectionTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allReferents = ref.watch(
      interviewersSelectionProvider(getRouteArg<int?>(context)),
    );

    return allReferents.when(
      skipError: true,
      skipLoadingOnReload: true,
      data:
          (data) => TableWidget(
            columns: [
              dataColumnWidget('Nome'),
              dataColumnWidget('Ruolo'),
              dataColumnWidget('Email'),
              dataColumnWidget('Associa'),
            ],
            dataRow: buildColoredRow(
              list: data,
              cells:
                  (referent, _) => [
                    DataCell(CompanyReferentBadge(referent)),
                    DataCell(Text(referent.role.displaName)),
                    DataCell(Text(referent.email)),
                    DataCell(_AssociateButton(referent)),
                  ],
            ),
          ),
      error: (error, stackTrace) => SizedBox.shrink(),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

class _AssociateButton extends ConsumerWidget {
  const _AssociateButton(this.referent);

  final CompanyReferentUi referent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeArg = getRouteArg<int?>(context);
    final isInterviewIdNull = ref.watch(isInterviewIdNullProvider(routeArg));

    return AssociateButtonWidget(
      isInterviewIdNull
          ? () {}
          : () {
            final notifier = ref.read(
              selectedReferentsForInterviewProvider(routeArg).notifier,
            );
            notifier.addReferent(referent);
          },
    );
  }
}
