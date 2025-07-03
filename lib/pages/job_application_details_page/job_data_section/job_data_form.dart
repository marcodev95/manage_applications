import 'package:manage_applications/models/job_data/job_data.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/widgets/components/dropdown_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/date_picker_widget.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobDataForm extends ConsumerStatefulWidget {
  const JobDataForm({super.key});

  @override
  ConsumerState<JobDataForm> createState() => _JobAnnouncementFormWidgetState();
}

class _JobAnnouncementFormWidgetState extends ConsumerState<JobDataForm>
    with AutomaticKeepAliveClientMixin<JobDataForm> {
  final _formKey = GlobalKey<FormState>();
  final _positionController = TextEditingController();
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
      final currentJobData = value.jobData;
      _positionController.text = currentJobData.position;
      _linkController.text = currentJobData.websiteUrl;
      _dayInOfficeController.text = currentJobData.dayInOffice ?? "";
      _experienceController.text = currentJobData.experience ?? "";
      _applyDateNotifier.value = currentJobData.applyDate;
      _workTypeNotifier.value = currentJobData.workType;
      _applicationStatus.value = currentJobData.applicationStatus;
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
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: RequiredFormFieldWidget(
                    controller: _positionController,
                    label: "Posizione",
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: DatePickerWidget(
                    label: "Data candidatura",
                    selectedDate: _applyDateNotifier,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Expanded(
                  child: RequiredFormFieldWidget(
                    controller: _linkController,
                    label: "Link annuncio",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Expanded(
                  child: DropdownWidget(
                    label: "Stato della candidatura",
                    items: ApplicationStatus.values.toDropdownItems(
                      (e) => e.displayName,
                    ),
                    selectedValue: _applicationStatus,
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: DropdownWidget(
                    label: "Tipologia di lavoro",
                    items: JobDataWorkType.values.toDropdownItems(
                      (e) => e.displayName,
                    ),
                    selectedValue: _workTypeNotifier,
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: FormFieldWidget(
                    controller: _dayInOfficeController,
                    label: "Giorni in ufficio",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [SaveButtonWidget(onPressed: _submit)],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newId = ref.read(jobDataFormController).value?.id;

      final jobData = JobData(
        id: newId,
        websiteUrl: _linkController.text,
        position: _positionController.text,
        experience: _experienceController.text,
        workType: _workTypeNotifier.value,
        dayInOffice: _dayInOfficeController.text,
        applyDate: _applyDateNotifier.value,
        applicationStatus: _applicationStatus.value,
      );

      final notifier = ref.read(jobDataFormController.notifier);

      final submit =
          jobData.id == null
              ? await notifier.addJobData(jobData)
              : await notifier.updateJobData(jobData);

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
    super.dispose();
  }
}
