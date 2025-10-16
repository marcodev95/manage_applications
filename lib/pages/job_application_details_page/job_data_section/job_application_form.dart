import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/job_application/job_application.dart';
import 'package:manage_applications/models/job_application/job_entry.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/date_picker_widget.dart';
import 'package:manage_applications/widgets/components/dropdown_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';

class JobApplicationForm extends ConsumerStatefulWidget {
  const JobApplicationForm({super.key});

  @override
  ConsumerState<JobApplicationForm> createState() =>
      _JobApplicationFormWidgetState();
}

class _JobApplicationFormWidgetState extends ConsumerState<JobApplicationForm>
    with AutomaticKeepAliveClientMixin<JobApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _positionController = TextEditingController();
  final _workPlaceController = TextEditingController();
  final _linkController = TextEditingController();
  final _experienceController = TextEditingController();
  final _dayInOfficeController = TextEditingController();
  final _applyDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final _workTypeNotifier = ValueNotifier<JobDataWorkType>(
    JobDataWorkType.hybrid,
  );
  final _applicationStatus = ValueNotifier<ApplicationStatus>(
    ApplicationStatus.apply,
  );

  @override
  void initState() {
    super.initState();

    final currentDetails = ref.read(fetchJobApplicationDetailsProvider);
    debugPrint('Current => $currentDetails');

    currentDetails.whenData((value) {
      final jobApplication = value.jobApplication;
      final jobEntry = jobApplication.jobEntry;
      _positionController.text = jobEntry.position;
      _linkController.text = jobEntry.url;
      _dayInOfficeController.text = jobEntry.dayInOffice ?? "";
      _experienceController.text = jobApplication.experience ?? "";
      _applyDateNotifier.value = jobApplication.applyDate;
      _workTypeNotifier.value = jobEntry.workType;
      _applicationStatus.value = jobApplication.applicationStatus;
      _workPlaceController.text = jobEntry.workPlace ?? "";
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 30.0,
          children: [
            Row(
              spacing: 20,
              children: [
                Expanded(
                  flex: 6,
                  child: RequiredFormFieldWidget(
                    controller: _positionController,
                    label: "Posizione (*)",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DatePickerWidget(
                    label: "Data candidatura",
                    selectedDate: _applyDateNotifier,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownWidget(
                    label: "Stato della candidatura",
                    items: ApplicationStatus.values.toDropdownItems(
                      (e) => e.displayName,
                    ),
                    selectedValue: _applicationStatus,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RequiredFormFieldWidget(
                    controller: _linkController,
                    label: "Link annuncio (*)",
                  ),
                ),
              ],
            ),
            Row(
              spacing: 20.0,
              children: [
                Expanded(
                  child: DropdownWidget(
                    label: "Tipologia di lavoro",
                    items: JobDataWorkType.values.toDropdownItems(
                      (e) => e.displayName,
                    ),
                    selectedValue: _workTypeNotifier,
                  ),
                ),
                Expanded(
                  child: FormFieldWidget(
                    controller: _dayInOfficeController,
                    label: "Giorni in ufficio",
                  ),
                ),
                Expanded(
                  child: _WorkPlaceField(
                    _workPlaceController,
                    _workTypeNotifier,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Consumer(
                builder: (_, ref, __) {
                  return ref
                      .watch(jobApplicationProvider)
                      .maybeWhen(
                        loading: () => const CircularProgressIndicator(),
                        orElse: () => SaveButtonWidget(onPressed: _submit),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newId = ref.read(jobApplicationProvider).value?.jobEntry.id;

      final jobEntry = JobEntry(
        id: newId,
        position: _positionController.text,
        workType: _workTypeNotifier.value,
        url: _linkController.text,
        workPlace: _workPlaceController.text,
        dayInOffice: _dayInOfficeController.text,
      );

      final jobApplication = JobApplication(
        jobEntry: jobEntry,
        experience: _experienceController.text,
        applyDate: _applyDateNotifier.value,
        applicationStatus: _applicationStatus.value,
      );

      final notifier = ref.read(jobApplicationProvider.notifier);

      final submit =
          jobEntry.id == null
              ? await notifier.addJobApplication(jobApplication)
              : await notifier.updateJobApplication(jobApplication);

      if (!mounted) return;

      submit.handleResult(context: context, ref: ref);
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _linkController.dispose();
    _applyDateNotifier.dispose();
    _experienceController.dispose();
    _dayInOfficeController.dispose();
    _workTypeNotifier.dispose();
    _applicationStatus.dispose();
    _workPlaceController.dispose();
    super.dispose();
  }
}

class _WorkPlaceField extends StatefulWidget {
  const _WorkPlaceField(this.controller, this.notifier);

  final TextEditingController controller;
  final ValueNotifier<JobDataWorkType> notifier;

  @override
  State<_WorkPlaceField> createState() => __WorkPlaceFieldState();
}

class __WorkPlaceFieldState extends State<_WorkPlaceField> {
  late final VoidCallback _notifierListener;
  final fieldLabel = "Luogo di lavoro";

  @override
  void initState() {
    super.initState();

    _notifierListener = () {
      final value = widget.notifier.value;
      if (value.isRemote) {
        widget.controller.clear();
      }
    };

    widget.notifier.addListener(_notifierListener);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<JobDataWorkType>(
      valueListenable: widget.notifier,
      builder: (_, value, __) {
        final isActive = value.isRemote;
        final isRequired = value != JobDataWorkType.remote;
        final validator =
            isRequired ? (String? v) => baseValidator(v, fieldLabel) : null;

        return FormFieldWidget(
          controller: widget.controller,
          label: fieldLabel,
          readOnly: isActive,
          isRequired: isRequired,
          validator: validator,
        );
      },
    );
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_notifierListener);
    super.dispose();
  }
}
