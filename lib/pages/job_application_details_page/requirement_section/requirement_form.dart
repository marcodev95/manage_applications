import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/requirement.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/requirement_section/requirements_provider.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequirementFormWidget extends ConsumerStatefulWidget {
  const RequirementFormWidget({super.key, this.requirement});

  final Requirement? requirement;

  @override
  ConsumerState<RequirementFormWidget> createState() =>
      _RequirementFormWidgetState();
}

class _RequirementFormWidgetState extends ConsumerState<RequirementFormWidget>
    with AutomaticKeepAliveClientMixin<RequirementFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _requirementController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.requirement != null) {
      _requirementController.text = widget.requirement!.requirement;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            spacing: 30.0,
            children: [
              Expanded(
                child: RequiredFormFieldWidget(
                  controller: _requirementController,
                  label: 'Requisito',
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _SaveButton(() => submit()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      final jobApplicationId = ref.read(jobApplicationProvider).value?.id;

      final requirement = Requirement(
        id: widget.requirement?.id,
        requirement: _requirementController.text,
        jobApplicationId: jobApplicationId,
      );

      final reqId = requirement.id;

      final requirementsNotifier = ref.read(requirementsProvider.notifier);

      final submit =
          reqId == null
              ? await requirementsNotifier.addRequirement(requirement)
              : await requirementsNotifier.updateRequirement(requirement);

      if (!mounted) return;

      submit.handleResult(context: context, ref: ref);

      if (reqId != null) {
        Navigator.pop(context);
      } else {
        _requirementController.clear();
      }
    }
  }

  @override
  void dispose() {
    _requirementController.dispose();
    super.dispose();
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton(this.onPressed);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(requirementsProvider).isLoading;
    return isLoading
        ? CircularProgressIndicator()
        : SaveButtonWidget(onPressed: onPressed);
  }
}
