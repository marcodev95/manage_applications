import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_place_field.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_provider.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/calendar_widget.dart';
import 'package:manage_applications/widgets/components/dropdown_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/time_picker_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewDataForm extends ConsumerStatefulWidget {
  const InterviewDataForm(this.interview, {super.key});

  final Interview interview;

  @override
  ConsumerState<InterviewDataForm> createState() => _InterviewDataFormState();
}

class _InterviewDataFormState extends ConsumerState<InterviewDataForm> {
  final _formKey = GlobalKey<FormState>();
  final _interviewTypeNotifier = ValueNotifier<InterviewTypes>(
    InterviewTypes.conoscitivo,
  );
  final _interviewDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final _interviewTimeNotifier = ValueNotifier<TimeOfDay>(TimeOfDay.now());
  final _interviewPlaceController = TextEditingController();
  final _interviewAnswerController = TextEditingController();

  final _interviewFormatNotifier = ValueNotifier<InterviewsFormat>(
    InterviewsFormat.online,
  );
  final _interviewStatusNotifier = ValueNotifier<InterviewStatus>(
    InterviewStatus.toDo,
  );
  final _interviewNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final interview = widget.interview;
    if (interview.id != null) {
      _interviewTypeNotifier.value = interview.type;
      _interviewDateNotifier.value = interview.date;
      _interviewTimeNotifier.value = interview.time;
      _interviewNotesController.text = interview.notes ?? '';
      _interviewStatusNotifier.value = interview.status;
      _interviewAnswerController.text = interview.answerTime ?? 'Da definire';

      _interviewFormatNotifier.value = interview.interviewFormat;
      _interviewPlaceController.text = interview.interviewPlace;
    }

    debugPrint('Interview DatFormInitState => $interview');
  }

  @override
  Widget build(BuildContext context) {
    final routeArg = getRouteArg<int?>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(AppStyle.pad24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 20.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: _InterviewCalendar(_interviewDateNotifier, routeArg),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 40.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Row(
                            spacing: 20.0,
                            children: [
                              Expanded(
                                child: DropdownWidget(
                                  label: "Tipo colloquio(*)",
                                  items: InterviewTypes.values.toDropdownItems(
                                    (e) => e.displayName,
                                  ),
                                  selectedValue: _interviewTypeNotifier,
                                ),
                              ),
                              Expanded(
                                child: DropdownWidget(
                                  label: "Stato del colloquio(*)",
                                  items: InterviewStatus.values.toDropdownItems(
                                    (e) => e.displayName,
                                  ),
                                  selectedValue: _interviewStatusNotifier,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TimePickerWidget(
                          label: "Ora del colloquio(*)",
                          selectedTime: _interviewTimeNotifier,
                        ),

                        Flexible(
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownWidget(
                                  label: 'Svolgimento colloquio(*)',
                                  items: InterviewsFormat.values
                                      .toDropdownItems((e) => e.displayName),
                                  selectedValue: _interviewFormatNotifier,
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                flex: 2,
                                child: InterviewPlaceField(
                                  controller: _interviewPlaceController,
                                  notifier: _interviewFormatNotifier,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FormFieldWidget(
                          controller: _interviewAnswerController,
                          label: 'Tempo stimato per la risposta',
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              InterviewNotesSection(controller: _interviewNotesController),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: _SaveButton(() => submit(routeArg), routeArg),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit(int? routeArg) async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(interviewFormProvider(routeArg).notifier);
      final interviewId = ref.read(interviewFormProvider(routeArg)).value?.id;

      final result =
          interviewId == null
              ? await notifier.createInterview(_buildInterview(routeArg))
              : await notifier.updateInterview(_buildInterview(routeArg));

      if (!mounted) return;

      result.handleResult(context: context, ref: ref);
    }
  }

  Interview _buildInterview(int? routeArg) {
    return Interview(
      id: ref.read(interviewFormProvider(routeArg)).value?.id,
      type: _interviewTypeNotifier.value,
      date: _interviewDateNotifier.value,
      time: _interviewTimeNotifier.value,
      status: _interviewStatusNotifier.value,
      interviewFormat: _interviewFormatNotifier.value,
      answerTime: _interviewAnswerController.text,
      interviewPlace: _interviewPlaceController.text,
      notes: _interviewNotesController.text,
      jobDataId: ref.read(jobDataProvider).value?.id,
    );
  }

  @override
  void dispose() {
    _interviewTypeNotifier.dispose();
    _interviewDateNotifier.dispose();
    _interviewTimeNotifier.dispose();
    _interviewPlaceController.dispose();
    _interviewNotesController.dispose();
    _interviewFormatNotifier.dispose();
    _interviewAnswerController.dispose();
    _interviewStatusNotifier.dispose();
    super.dispose();
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton(this.callback, this.routeArg);

  final VoidCallback callback;
  final int? routeArg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(interviewFormProvider(routeArg)).isLoading;

    return isLoading
        ? const CircularProgressIndicator()
        : SaveButtonWidget(onPressed: callback);
  }
}

class InterviewNotesSection extends StatelessWidget {
  final TextEditingController controller;

  const InterviewNotesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note sul colloquio',
          style: TextStyle(
            fontSize: AppStyle.tableTextFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        FormFieldWidget(
          controller: controller,
          label: '',
          minLines: 4,
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}

class _InterviewCalendar extends ConsumerWidget {
  const _InterviewCalendar(this.interviewDateNotifier, this.routeArg);

  final ValueNotifier<DateTime> interviewDateNotifier;
  final int? routeArg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thereIsInterviewId = ref.watch(
      interviewFormProvider(
        routeArg,
      ).select((value) => value.hasValue && value.value!.id != null),
    );

    return AbsorbPointer(
      absorbing: thereIsInterviewId,
      child: CalendarWidget(
        label: 'Data colloquio',
        selectedDate: interviewDateNotifier,
      ),
    );
  }
}
