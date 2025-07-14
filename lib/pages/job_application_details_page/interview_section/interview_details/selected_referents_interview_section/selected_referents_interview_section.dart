import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/is_interview_id_null_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/interviewers_selection/interviewers_selection_table.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/change_screen_referents_table_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_table/selected_referents_interview_table.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_table/selected_referents_interview_notifier.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class SelectedReferentsInterviewSection extends ConsumerWidget {
  const SelectedReferentsInterviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeArg = getRouteArg<int?>(context);
    ref.listenOnErrorWithSnackbar(
      provider: selectedReferentsForInterviewProvider(routeArg),
      context: context,
    );

    final screen = ref.watch(changeScreenReferentsTableProvider);
    return Column(
      children: [
        Offstage(
          offstage: screen != ScreenReferentsTable.selected,
          child: SectionWidget(
            title: 'Lista dei referenti associati al colloquio',
            trailing: const _AssociateButton(),
            body: SelectedReferentsInterviewTable(),
          ),
        ),

        Offstage(
          offstage: screen != ScreenReferentsTable.selection,
          child: SectionWidget(
            title: 'Lista dei referenti da scegliere',
            trailing: TextButtonWidget(
              onPressed:
                  () =>
                      ref
                          .read(changeScreenReferentsTableProvider.notifier)
                          .state = ScreenReferentsTable.selected,
              label: 'Torna alla lista dei referenti associati',
            ),

            body: InterviewersSelectionTable(routeArg: routeArg),
          ),
        ),
      ],
    );
  }
}

class _AssociateButton extends ConsumerWidget {
  const _AssociateButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInterviewIdNull = ref.watch(
      isInterviewIdNullProvider(getRouteArg<int?>(context)),
    );

    return TextButtonWidget(
      onPressed:
          isInterviewIdNull
              ? () {}
              : () {
                ref.read(changeScreenReferentsTableProvider.notifier).state =
                    ScreenReferentsTable.selection;
              },
      isEnable: !isInterviewIdNull,
      label: 'Associa referenti',
    );
  }
}
