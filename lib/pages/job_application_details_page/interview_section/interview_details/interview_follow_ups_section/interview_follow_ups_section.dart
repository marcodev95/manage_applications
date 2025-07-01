import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/states/change_screen_state.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_follow_ups_section/form/interview_follow_up_form.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_follow_ups_section/interview_follow_ups_table/interview_follow_ups_table.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/is_interview_id_null_provider.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewFollowUpsSection extends StatefulWidget {
  const InterviewFollowUpsSection({super.key});

  @override
  State<InterviewFollowUpsSection> createState() =>
      _InterviewFollowUpsSectionState();
}

class _InterviewFollowUpsSectionState extends State<InterviewFollowUpsSection> {
  final _screenNotifer = ValueNotifier<ScreenState<InterviewFollowUp?>>(
    ScreenState(screen: ViewModel.list),
  );

  void goToForm([InterviewFollowUp? followUp]) {
    _screenNotifer.value = ScreenState(screen: ViewModel.form, data: followUp);
  }

  void goToList() {
    _screenNotifer.value = ScreenState(screen: ViewModel.list);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _screenNotifer,
      builder: (_, value, __) {
        return Column(
          children: [
            Offstage(
              offstage: value.screen != ViewModel.list,
              child: SectionWidget(
                title: 'Elenco dei follow-ups',
                trailing: _OpenFollowUpDailogButton(goToForm),
                body: InterviewFollowUpsTable((followUp) => goToForm(followUp)),
              ),
            ),
            Visibility(
              visible: value.screen == ViewModel.form,
              child: SectionWidget(
                title: 'Dettagli follow-up',
                trailing: _GoBackToListButton(goToList),
                body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InterviewFollowUpForm(followUp: value.data),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
/* Offstage =>
  Serve quando vuoi "nascondere" un widget senza distruggerlo (cioè senza smontarlo), ad esempio:
  conservare lo stato di un form, mantenere un provider autoDispose attivo, evitare ricostruzioni costose 
*/

class _OpenFollowUpDailogButton extends ConsumerWidget {
  const _OpenFollowUpDailogButton(this.goToForm);

  final void Function() goToForm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInterviewIdNull = ref.watch(
      isInterviewIdNullProvider(getRouteArg<int?>(context)),
    );

    return TextButtonWidget(
      onPressed: isInterviewIdNull ? () {} : () => goToForm(),
      label: 'Aggiungi follow-up',
      isEnable: !isInterviewIdNull,
    );
  }
}

class _GoBackToListButton extends ConsumerWidget {
  const _GoBackToListButton(this.goToList);

  final void Function() goToList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButtonWidget(
      onPressed: () => goToList(),
      label: 'Torna alla lista',
    );
  }
}
