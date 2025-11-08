import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/interview/referent_with_affiliation.dart';
import 'package:manage_applications/models/job_application/job_application_referent.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/referent/referent_details.dart';
import 'package:manage_applications/models/shared/company_option.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_barrel.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/dropdown_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/responsive_layout_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class CompanyReferentForm extends ConsumerWidget {
  const CompanyReferentForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(
      companyChangeScreenProvider.select((value) => value.data?.referentId),
    );

    if (id == null) return CompanyReferentFormBody();

    ref.listenOnErrorWithoutSnackbar(
      provider: referentDetailsProvider(id),
      context: context,
    );

    final asyncCompanyReferentDetails = ref.watch(referentDetailsProvider(id));

    return asyncCompanyReferentDetails.when(
      data: (data) => CompanyReferentFormBody(referent: data),
      error:
          (_, __) => DataLoadErrorScreenWidget(
            onPressed: () => ref.invalidate(referentDetailsProvider(id)),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class CompanyReferentFormBody extends ConsumerStatefulWidget {
  const CompanyReferentFormBody({super.key, this.referent});

  final ReferentDetails? referent;

  @override
  ConsumerState<CompanyReferentFormBody> createState() =>
      _CompanyReferentFormState();
}

class _CompanyReferentFormState extends ConsumerState<CompanyReferentFormBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = ValueNotifier<RoleType>(RoleType.hr);
  late final ValueNotifier<CompanyOption> _referentCompanyNotifier;

  @override
  void initState() {
    super.initState();

    _referentCompanyNotifier = ValueNotifier(
      ref.read(referentCompanyOptionsProvider).first,
    );

    final referentDetails = widget.referent;

    if (referentDetails != null) {
      final referent =
          referentDetails
              .jobApplicationReferent
              .referentWithAffiliation
              .referent;
      final company = referentDetails.company;
      _nameController.text = referent.name;
      _emailController.text = referent.email;
      _phoneController.text = referent.phoneNumber ?? "";
      _roleController.value = referent.role;
      _referentCompanyNotifier.value = company;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 40.0,
        children: [
          ResponsiveLayoutWidget(
            desktop: (_, __) {
              return Column(
                spacing: 40.0,
                children: [
                  Row(
                    spacing: 20.0,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _ReferentNameField(_nameController),
                      ),
                      Expanded(
                        child: _ReferentCompanyDropdown(
                          _referentCompanyNotifier,
                        ),
                      ),
                      Expanded(child: _ReferentRoleDropdown(_roleController)),
                    ],
                  ),
                  Row(
                    spacing: 20.0,
                    children: [
                      Expanded(child: _ReferentEmailField(_emailController)),
                      Expanded(child: _ReferentPhoneField(_phoneController)),
                    ],
                  ),
                ],
              );
            },
            compact: (_, __) {
              return Column(
                spacing: 40.0,
                children: [
                  _ReferentNameField(_nameController),
                  Row(
                    spacing: 20.0,
                    children: [
                      Expanded(
                        child: _ReferentCompanyDropdown(
                          _referentCompanyNotifier,
                        ),
                      ),
                      Expanded(child: _ReferentRoleDropdown(_roleController)),
                    ],
                  ),
                  _ReferentEmailField(_emailController),

                  _ReferentPhoneField(_phoneController),
                ],
              );
            },
          ),
          _SaveButton(() => _submit()),
        ],
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final referentsNotifier = ref.read(referentsProvider.notifier);

      final referentId =
          widget
              .referent
              ?.jobApplicationReferent
              .referentWithAffiliation
              .referent
              .id;

      final referent = Referent(
        id: referentId,
        name: _nameController.text,
        role: _roleController.value,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        companyId: _referentCompanyNotifier.value.companyRef.id,
      );

      final jobAppReferent = JobApplicationReferent(
        applicationId: ref.read(jobApplicationProvider).value?.jobEntry.id,
        referentWithAffiliation: ReferentWithAffiliation(
          referent: referent,
          affiliation: _referentCompanyNotifier.value.companyType,
        ),
      );

      final submit =
          referent.id == null
              ? await referentsNotifier.addReferent(jobAppReferent)
              : await referentsNotifier.updateReferent(jobAppReferent);

      if (!mounted) return;

      submit.handleResult(context: context, ref: ref);

      if (referentId == null && submit.isSuccess) {
        _resetForm();
      }
    }
  }

  void _resetForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _roleController.value = RoleType.hr;
    _referentCompanyNotifier.value =
        ref.read(referentCompanyOptionsProvider).first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _referentCompanyNotifier.dispose();

    super.dispose();
  }
}

class _ReferentCompanyDropdown extends ConsumerWidget {
  const _ReferentCompanyDropdown(this.referentCompanyNotifier);

  final ValueNotifier<CompanyOption> referentCompanyNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownWidget(
      label: "Azienda a cui è associato(*)",
      items: ref
          .watch(referentCompanyOptionsProvider)
          .toDropdownItems((e) => e.companyRef.name),
      selectedValue: referentCompanyNotifier,
    );
  }
}

class _ReferentNameField extends StatelessWidget {
  const _ReferentNameField(this.nameController);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return RequiredFormFieldWidget(
      controller: nameController,
      label: "Nome referente(*)",
    );
  }
}

class _ReferentRoleDropdown extends StatelessWidget {
  const _ReferentRoleDropdown(this.roleNotifier);

  final ValueNotifier<RoleType> roleNotifier;

  @override
  Widget build(BuildContext context) {
    return DropdownWidget(
      label: "Ruolo referente(*)",
      items: RoleType.values.toDropdownItems((e) => e.displayName),
      selectedValue: roleNotifier,
    );
  }
}

class _ReferentEmailField extends StatelessWidget {
  const _ReferentEmailField(this.emailController);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return RequiredFormFieldWidget(
      controller: emailController,
      label: "Email referente(*)",
    );
  }
}

class _ReferentPhoneField extends StatelessWidget {
  const _ReferentPhoneField(this.phoneController);

  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      controller: phoneController,
      label: "Numero di telefono referente",
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton(this.callback);

  final VoidCallback callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(referentsProvider).isLoading;

    return isLoading
        ? const CircularProgressIndicator()
        : Align(
          alignment: Alignment.centerRight,
          child: SaveButtonWidget(onPressed: callback),
        );
  }
}
