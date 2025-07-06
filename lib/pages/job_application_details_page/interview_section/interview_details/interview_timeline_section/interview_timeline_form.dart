import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/interview_timeline_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/interview_timeline_utility.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/date_picker_widget.dart';
import 'package:manage_applications/widgets/components/dropdown_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/time_picker_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewTimelineForm extends ConsumerStatefulWidget {
  const InterviewTimelineForm({
    super.key,
    this.routeID,
    required this.goToList,
  });

  final int? routeID;
  final void Function() goToList;

  @override
  ConsumerState<InterviewTimelineForm> createState() =>
      _InterviewTimelineFormState();
}

class _InterviewTimelineFormState extends ConsumerState<InterviewTimelineForm> {
  final _formKey = GlobalKey<FormState>();

  final _eventTypeNotifier = ValueNotifier(InterviewTimelineEvent.done);
  final _eventDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final _eventTimeNotifier = ValueNotifier<TimeOfDay>(TimeOfDay.now());

  final _newDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final _newTimeNotifier = ValueNotifier<TimeOfDay>(TimeOfDay.now());

  final _relocatedAddress = TextEditingController();

  final _followUpSentAtDate = ValueNotifier<DateTime>(DateTime.now());
  final _followUpSentAtTime = ValueNotifier<TimeOfDay>(TimeOfDay.now());
  final _followUpSentTo = TextEditingController();

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 25.0,
        children: [
          Row(
            spacing: 30.0,
            children: [
              Expanded(
                child: DropdownWidget(
                  label: 'Evento dello storico',
                  items: InterviewTimelineEvent.values.toDropdownItems(
                    (tl) => tl.displayName,
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

          ValueListenableBuilder<InterviewTimelineEvent>(
            valueListenable: _eventTypeNotifier,
            builder: (_, value, __) {
              return switch (value) {
                InterviewTimelineEvent.done => const SizedBox.shrink(),
                InterviewTimelineEvent.postponed => _PostponedFields(
                  newDateNotifier: _newDateNotifier,
                  newTimeNotifier: _newTimeNotifier,
                  reasonController: _reasonController,
                  requesterController: _requesterController,
                ),
                InterviewTimelineEvent.cancelled => _CancelledFields(
                  reasonController: _reasonController,
                  requesterController: _requesterController,
                ),
                InterviewTimelineEvent.relocated => _RelocatedField(
                  _relocatedAddress,
                ),
                InterviewTimelineEvent.followUpSent => _FollowUpSentFields(
                  followUpSentAtDate: _followUpSentAtDate,
                  followUpSentAtTime: _followUpSentAtTime,
                  followUpSentTo: _followUpSentTo,
                ),
              };
            },
          ),

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
                        .watch(interviewTimelineProvider(widget.routeID))
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

  void submit() async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(
        interviewTimelineProvider(widget.routeID).notifier,
      );

      final submit = await notifier.addTimeline(_toUI());
      if (!mounted) return;

      submit.handleResult(context: context, ref: ref);

      if (submit.isSuccess) widget.goToList();
    }
  }

  InterviewTimeline _toUI() {
    final isPostponed = _eventTypeNotifier.value.isPostponed;

    final interview = ref.read(interviewFormProvider(widget.routeID)).value!;

    return InterviewTimeline(
      eventType: _eventTypeNotifier.value,
      eventDateTime: buildDateTime(
        _eventDateNotifier.value,
        _eventTimeNotifier.value,
      ),
      note: _noteController.text,
      originalDateTime:
          isPostponed ? buildDateTime(interview.date, interview.time) : null,
      newDateTime:
          isPostponed
              ? buildDateTime(_newDateNotifier.value, _newTimeNotifier.value)
              : null,
      followUpSentTo: _followUpSentTo.text,
      followUpSentAt: buildDateTime(
        _followUpSentAtDate.value,
        _followUpSentAtTime.value,
      ),
      relocatedAddress: _relocatedAddress.text,
      reason: _reasonController.text,
      requester: _requesterController.text,
      interviewId: interview.id,
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
    _followUpSentAtDate.dispose();
    _followUpSentAtTime.dispose();
    _followUpSentTo.dispose();
    _relocatedAddress.dispose();
    _noteController.dispose();
    super.dispose();
  }
}

class _FollowUpSentFields extends StatelessWidget {
  const _FollowUpSentFields({
    required this.followUpSentAtDate,
    required this.followUpSentAtTime,
    required this.followUpSentTo,
  });

  final ValueNotifier<DateTime> followUpSentAtDate;
  final ValueNotifier<TimeOfDay> followUpSentAtTime;
  final TextEditingController followUpSentTo;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20.0,
      children: [
        Expanded(
          child: DatePickerWidget(
            label: 'Data invio',
            selectedDate: followUpSentAtDate,
          ),
        ),
        Expanded(
          child: TimePickerWidget(
            label: 'Ora invio',
            selectedTime: followUpSentAtTime,
          ),
        ),
        Expanded(
          child: RequiredFormFieldWidget(
            label: 'Inviato a ',
            controller: followUpSentTo,
          ),
        ),
      ],
    );
  }
}

class _RelocatedField extends StatelessWidget {
  const _RelocatedField(this.relocatedAddress);

  final TextEditingController relocatedAddress;

  @override
  Widget build(BuildContext context) {
    return RequiredFormFieldWidget(
      controller: relocatedAddress,
      label: 'Nuovo indirizzo',
    );
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
                label: 'Chi ha chiesto il rinvio',
                controller: requesterController,
              ),
            ),
            Expanded(
              child: RequiredFormFieldWidget(
                controller: reasonController,
                label: 'Motivazioni per il rinvio del colloquio',
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
