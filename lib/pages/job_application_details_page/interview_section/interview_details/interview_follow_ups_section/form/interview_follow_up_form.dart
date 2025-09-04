import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/provider/interview_timeline_follow_up_events_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/service/interview_follow_up_service.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/date_picker_widget.dart';
import 'package:manage_applications/widgets/components/dropdown_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';

class InterviewFollowUpForm extends ConsumerStatefulWidget {
  const InterviewFollowUpForm({
    super.key,
    this.followUp,
    this.routeID,
    required this.goToList,
  });

  final InterviewFollowUp? followUp;
  final int? routeID;
  final void Function() goToList;

  @override
  ConsumerState<InterviewFollowUpForm> createState() =>
      _InterviewFollowUpFormState();
}

class _InterviewFollowUpFormState extends ConsumerState<InterviewFollowUpForm> {
  final formKey = GlobalKey<FormState>();
  final followUpTypeController = TextEditingController();
  final followUpDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final followUpNotesController = TextEditingController();
  final responseReceivedNotifier = ValueNotifier<ResponseReceived>(
    ResponseReceived.no,
  );

  @override
  void initState() {
    super.initState();
    final followUp = widget.followUp;
    if (followUp != null) {
      followUpTypeController.text = followUp.followUpType;
      followUpDateNotifier.value = followUp.followUpDate;
      followUpNotesController.text = followUp.followUpNotes ?? '';
      responseReceivedNotifier.value = followUp.responseReceived;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: 20.0,
            children: [
              Flexible(
                child: RequiredFormFieldWidget(
                  controller: followUpTypeController,
                  label: "Tipo follow-up(*)",
                ),
              ),
              Flexible(
                child: DatePickerWidget(
                  label: 'Data invio follow-up(*)',
                  selectedDate: followUpDateNotifier,
                ),
              ),
              Flexible(
                child: DropdownWidget(
                  label: 'Risposta ricevuta(*)',
                  items: ResponseReceived.values.toDropdownItems(
                    (e) => e.displayName,
                  ),
                  selectedValue: responseReceivedNotifier,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Flexible(
            child: FormFieldWidget(
              controller: followUpNotesController,
              label: 'Note',
              minLines: 6,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          const SizedBox(height: 40.0),
          Align(
            alignment: Alignment.centerRight,
            child: Consumer(
              builder: (context, ref, child) {
                final isLoading =
                    ref.watch(followUpEventsProvider(widget.routeID)).isLoading;
                return isLoading
                    ? const CircularProgressIndicator()
                    : SaveButtonWidget(onPressed: () => _submit());
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    followUpNotesController.dispose();
    followUpTypeController.dispose();
    followUpDateNotifier.dispose();
    responseReceivedNotifier.dispose();
    super.dispose();
  }

  void _submit() async {
    if (formKey.currentState!.validate()) {
      final interviewId =
          ref.read(interviewFormProvider(widget.routeID)).value?.id;

      final followUp = InterviewFollowUp(
        id: widget.followUp?.id,
        followUpDate: followUpDateNotifier.value,
        followUpType: followUpTypeController.text,
        followUpNotes: followUpNotesController.text,
        responseReceived: responseReceivedNotifier.value,
        interviewId: interviewId,
      );

      final service = ref.read(followUpService);
      final result = await service.createFollowUpWithEvent(
        followUp: followUp,
        routeArgID: widget.routeID,
      );

      if (!mounted) return;
      result.handleErrorResult(context: context, ref: ref);

      if (result.isSuccess) {
        widget.goToList();
      }
    }
  }
}
