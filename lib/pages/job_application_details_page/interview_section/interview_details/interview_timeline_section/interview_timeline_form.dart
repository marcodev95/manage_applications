import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/interview_timelines_provider.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/date_picker_widget.dart';
import 'package:manage_applications/widgets/components/dropdown_widget.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_panel_button_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/time_picker_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewTimelineForm extends StatelessWidget {
  const InterviewTimelineForm({super.key, this.routeID, this.interview});

  final int? routeID;
  final Interview? interview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica stato'),
        actions: const [ErrorsPanelButtonWidget()],
      ),

      body: AppCard(
        child: InterviewTimelineFormBody(
          routeID: routeID,
          interview: interview,
        ),
      ),
    );
  }
}

class InterviewTimelineFormBody extends ConsumerStatefulWidget {
  const InterviewTimelineFormBody({super.key, this.routeID, this.interview});

  final int? routeID;
  final Interview? interview;

  @override
  ConsumerState<InterviewTimelineFormBody> createState() =>
      _InterviewTimelineFormState();
}

class _InterviewTimelineFormState
    extends ConsumerState<InterviewTimelineFormBody> {
  final _formKey = GlobalKey<FormState>();

  final _eventTypeNotifier = ValueNotifier(InterviewStatus.toDo);
  final _eventDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final _eventTimeNotifier = ValueNotifier<TimeOfDay>(TimeOfDay.now());

  final _newDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final _newTimeNotifier = ValueNotifier<TimeOfDay>(TimeOfDay.now());

  final _reasonController = TextEditingController();
  final _requesterController = TextEditingController();

  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final interview = ref.read(interviewFormProvider(widget.routeID)).value;

    if (interview != null) {
      _newDateNotifier.value = interview.date;
      _newTimeNotifier.value = interview.time;
      _eventTypeNotifier.value = interview.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 25.0,
        children: [
          Row(
            spacing: 30.0,
            children: [
              Expanded(
                child: DropdownWidget(
                  label: 'Evento dello storico',
                  items: InterviewStatus.values.toDropdownItems(
                    (e) => e.displayName,
                  ),
                  selectedValue: _eventTypeNotifier,
                ),
              ),
              Expanded(
                child: DatePickerWidget(
                  label: 'Data evento',
                  selectedDate: _eventDateNotifier,
                  isDisabled: true,
                ),
              ),
              Expanded(
                child: TimePickerWidget(
                  label: 'Ora evento',
                  selectedTime: _eventTimeNotifier,
                  isDisabled: true,
                ),
              ),
            ],
          ),

          _buildFormBody(),

          FormFieldWidget(
            controller: _noteController,
            label: 'Note(Opzionali)',
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Consumer(
              builder: (_, ref, __) {
                final isLoading =
                    ref
                        .watch(interviewTimelinesProvider(widget.routeID))
                        .isLoading;

                return isLoading
                    ? const CircularProgressIndicator()
                    : SaveButtonWidget(onPressed: () => submit());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormBody() {
    return ValueListenableBuilder(
      valueListenable: _eventTypeNotifier,
      builder: (context, event, _) {
        return switch (event) {
          InterviewStatus.toDo => const SizedBox(),
          InterviewStatus.completed => const SizedBox(),
          InterviewStatus.postponed => _PostponedFields(
            newDateNotifier: _newDateNotifier,
            newTimeNotifier: _newTimeNotifier,
            reasonController: _reasonController,
            requesterController: _requesterController,
          ),
          InterviewStatus.cancelled => _CancelledFields(
            reasonController: _reasonController,
            requesterController: _requesterController,
          ),
        };
      },
    );
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(
        interviewTimelinesProvider(widget.routeID).notifier,
      );

      final submit = await notifier.addTimeline(_toUI());
      if (!mounted) return;

      submit.handleErrorResult(context: context, ref: ref);
    }
  }

  InterviewTimeline _toUI() {
    final isPostponed = _eventTypeNotifier.value == InterviewStatus.postponed;

    final interview = ref.read(interviewFormProvider(widget.routeID)).value;

    return InterviewTimeline(
      eventType: _eventTypeNotifier.value,
      eventDateTime: buildDateTime(
        _eventDateNotifier.value,
        _eventTimeNotifier.value,
      ),
      note: _noteController.text,
      originalDateTime:
          isPostponed ? buildDateTime(interview!.date, interview.time) : null,
      newDateTime:
          isPostponed
              ? buildDateTime(_newDateNotifier.value, _newTimeNotifier.value)
              : null,
      reason: _reasonController.text,
      requester: _requesterController.text,
      interviewId: interview!.id,
    );
  }

  @override
  void dispose() {
    _eventTypeNotifier.dispose();
    _eventDateNotifier.dispose();
    _eventTimeNotifier.dispose();
    _reasonController.dispose();
    _requesterController.dispose();
    _newDateNotifier.dispose();
    _newTimeNotifier.dispose();
    _noteController.dispose();
    super.dispose();
  }
}

class _CancelledFields extends StatelessWidget {
  const _CancelledFields({
    required this.reasonController,
    required this.requesterController,
  });

  final TextEditingController reasonController;
  final TextEditingController requesterController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 30,
          children: [
            Expanded(
              child: RequiredFormFieldWidget(
                label: 'Chi ha chiesto annullamento',
                controller: requesterController,
              ),
            ),
            Expanded(
              child: RequiredFormFieldWidget(
                controller: reasonController,
                label: 'Motivazioni per annullamento',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PostponedFields extends StatelessWidget {
  const _PostponedFields({
    required this.newDateNotifier,
    required this.newTimeNotifier,
    required this.reasonController,
    required this.requesterController,
  });

  final ValueNotifier<DateTime> newDateNotifier;
  final ValueNotifier<TimeOfDay> newTimeNotifier;
  final TextEditingController reasonController;
  final TextEditingController requesterController;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 25.0,
      children: [
        Row(
          spacing: 30,
          children: [
            Expanded(
              child: DatePickerWidget(
                label: 'Nuova data del colloquio',
                selectedDate: newDateNotifier,
              ),
            ),
            Expanded(
              child: TimePickerWidget(
                label: 'Nuovo orario del colloquio',
                selectedTime: newTimeNotifier,
              ),
            ),
            Expanded(
              child: RequiredFormFieldWidget(
                label: 'Chi ha chiesto il rinvio',
                controller: requesterController,
              ),
            ),
          ],
        ),

        RequiredFormFieldWidget(
          controller: reasonController,
          label: 'Motivazioni per il rinvio del colloquio',
        ),
      ],
    );
  }
}
