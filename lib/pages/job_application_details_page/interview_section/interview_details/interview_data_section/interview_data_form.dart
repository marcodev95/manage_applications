import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form/interview_form_field_barrel.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/interview_timeline_form.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/dropdown_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/time_picker_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

/// Refactor generale
/// Togliere ChangePlaceInterview
/// Gestire InterviewFollowUpTimeline e nella UI della card
/// Sistemare InterviewTimelineForm:
/// - Escludere DaFare nella lista della dropdown
/// - DaFare potrebbe diventare un evento timeline x creazione colloquio
/// - Capire come gestire lo spazio quando ho Completato
/// - Quando premo modifica dalla InterviewDetails, partire sempre da Completato e non dal valore attuale

class InterviewDataForm extends ConsumerStatefulWidget {
  const InterviewDataForm(this.interview, {super.key, this.routeId});

  final Interview interview;
  final int? routeId;

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
  final _interviewStatusController = TextEditingController();
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
      _interviewStatusController.text = interview.status.displayName;
      _interviewAnswerController.text = interview.answerTime ?? 'Da definire';

      _interviewFormatNotifier.value = interview.interviewFormat;
      _interviewPlaceController.text = interview.interviewPlace;
    } else {
      _interviewStatusController.text = InterviewStatus.toDo.displayName;
    }

    debugPrint('Interview DatFormInitState => $interview');
  }

  @override
  Widget build(BuildContext context) {
    final routeArg = widget.routeId;
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
                    child: InterviewCalendarField(
                      _interviewDateNotifier,
                      routeArg,
                    ),
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
                                child: Row(
                                  spacing: 10.0,
                                  children: [
                                    InterviewStatusField(
                                      routeID: routeArg,
                                      callback:
                                          () => navigatorPush(
                                            context,
                                            InterviewTimelineForm(
                                              routeID: routeArg,
                                              interview: widget.interview,
                                            ),
                                          ),
                                    ),
                                  ],
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
                            spacing: 20.0,
                            children: [
                              Expanded(
                                flex: 2,
                                child: DropdownWidget(
                                  label: 'Svolgimento colloquio(*)',
                                  items: InterviewsFormat.values
                                      .toDropdownItems((e) => e.displayName),
                                  selectedValue: _interviewFormatNotifier,
                                ),
                              ),
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

              InterviewNoteSection(controller: _interviewNotesController),
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
      final resultOrInterview = _buildInterview(routeArg);

      if (resultOrInterview.isFailure) {
        resultOrInterview.handleErrorResult(context: context, ref: ref);
        return;
      }

      final interview = resultOrInterview.data;

      final result =
          interview.id == null
              ? await notifier.createInterview(interview)
              : await notifier.updateInterview(interview);

      if (!mounted) return;

      result.handleResult(context: context, ref: ref);
    }
  }

  OperationResult<Interview> _buildInterview(int? routeArg) {
    final currentInterview = ref.read(interviewFormProvider(routeArg)).value;

    if (currentInterview == null) {
      return Failure(
        error: "Dati dell'intervista non disponibili per routeArg: $routeArg",
        message: 'Dati dell\'intervista non disponibili',
      );
    }

    return Success(
      data: Interview(
        id: currentInterview.id,
        type: _interviewTypeNotifier.value,
        date: _interviewDateNotifier.value,
        time: _interviewTimeNotifier.value,
        status: currentInterview.status,
        interviewFormat: _interviewFormatNotifier.value,
        answerTime: _interviewAnswerController.text,
        interviewPlace: _interviewPlaceController.text,
        notes: _interviewNotesController.text,
        jobApplicationId: ref.read(jobApplicationProvider).value?.id,
      ),
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
    _interviewStatusController.dispose();
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
