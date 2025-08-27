import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/interview_timeline_form.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/interview_timeline_list.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/is_interview_id_null_provider.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

/* Ricapitolando il flow ideale:

Tutta la modifica dello stato avviene tramite la timeline, 
che rimane la fonte ufficiale e storicizzata degli eventi,

Nei dettagli del colloquio mostri un campo readonly che indica lo stato attuale, 
derivato dall’ultimo evento della timeline,

Gli eventi una volta inseriti sono immodificabili per garantire integrità e tracciabilità. */

class InterviewTimelineSection extends StatefulWidget {
  const InterviewTimelineSection({super.key});

  @override
  State<InterviewTimelineSection> createState() =>
      _InterviewTimelineSectionState();
}

class _InterviewTimelineSectionState extends State<InterviewTimelineSection> {
  final _screenNotifer = ValueNotifier<ViewModel>(ViewModel.list);

  void goToForm() {
    _screenNotifer.value = ViewModel.form;
  }

  void goToList() {
    _screenNotifer.value = ViewModel.list;
  }

  @override
  Widget build(BuildContext context) {
    final routeArg = getRouteArg<int?>(context);

    return Padding(
      padding: EdgeInsets.all(AppStyle.pad16),
      child: Column(
        children: [
          SectionTitle('Timeline'),
          const Divider(thickness: 1),
          Flexible(child: InterviewTimelineList(routeID: routeArg,)),
        ],
      ),
    );

    /* return ValueListenableBuilder<ViewModel>(
      valueListenable: _screenNotifer,
      builder: (context, value, _) {
        return switch (value) {
          ViewModel.list => Padding(
            padding: EdgeInsets.all(AppStyle.pad16),
            child: Column(
              children: [
                SectionTitle(
                  'Timeline',
                  trailing: _GoToFormButton(goToForm, routeArg),
                ),
                const Divider(thickness: 1),
                Flexible(child: InterviewTimelineList(onEdit: goToForm)),
              ],
            ),
          ),
          ViewModel.form => SectionWidget(
            title: 'Dettagli timeline',
            trailing: TextButtonWidget(
              onPressed: () => goToList(),
              label: 'Torna allo storico',
            ),
            body: const SizedBox() /* Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InterviewTimelineForm<InterviewStatus>(
                routeID: routeArg,
                goToList: goToList,
                value: InterviewStatus.toDo,
                eventType: InterviewStatus.toDo.displayName,
              ),
            ), */,
          ),
        };
      },
    ); */
  }
}

class _GoToFormButton extends ConsumerWidget {
  const _GoToFormButton(this.goToForm, this.routeArg);

  final void Function() goToForm;
  final int? routeArg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInterviewIdNull = ref.watch(isInterviewIdNullProvider(routeArg));

    return TextButtonWidget(
      onPressed: isInterviewIdNull ? () {} : () => goToForm(),
      label: 'Inserisci nuovo evento',
      isEnable: !isInterviewIdNull,
    );
  }
}
