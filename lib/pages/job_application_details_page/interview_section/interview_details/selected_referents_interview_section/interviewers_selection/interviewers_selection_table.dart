import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/job_application/job_application_referent.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_badge.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/is_interview_id_null_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/interviewers_selection/interviewers_selection_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_table/selected_referents_interview_notifier.dart';
import 'package:manage_applications/widgets/components/button/associate_button_widget.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';

class InterviewersSelectionTable extends ConsumerWidget {
  const InterviewersSelectionTable({super.key, this.routeArg});

  final int? routeArg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allReferents = ref.watch(interviewersSelectionProvider(routeArg));

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
                    DataCell(Text(referent.referent.role.displayName)),
                    DataCell(Text(referent.referent.email)),
                    DataCell(_AssociateButton(referent, routeArg: routeArg,)),
                  ],
            ),
          ),
      error: (error, stackTrace) => SizedBox.shrink(),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

class _AssociateButton extends ConsumerWidget {
  const _AssociateButton(this.referent, {this.routeArg});

  final JobApplicationReferent referent;
  final int? routeArg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
