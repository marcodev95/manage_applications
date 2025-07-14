import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_barrel.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/dropdown_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
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

    final asyncCompanyReferentDetails = ref.watch(
      referentDetailsProvider(id),
    );

    return asyncCompanyReferentDetails.when(
      data: (data) => CompanyReferentFormBody(referent: data),
      error:
          (_, __) => DataLoadErrorScreenWidget(
            onPressed: () => ref.invalidate(referentDetailsProvider),
          ),
      loading: () => Center(child: CircularProgressIndicator()),
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
  late final ValueNotifier<CompanyOption> _referentCompanyController;

  @override
  void initState() {
    super.initState();

    _referentCompanyController = ValueNotifier(
      ref.read(referentCompanyOptionsProvider).first,
    );

    final referentDetails = widget.referent;

    if (referentDetails != null) {
      final referent = referentDetails.jobApplicationReferent.referent;
      final company = referentDetails.company;
      _nameController.text = referent.name;
      _emailController.text = referent.email;
      _phoneController.text = referent.phoneNumber ?? "";
      _roleController.value = referent.role;
      _referentCompanyController.value = company;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 40.0,
        children: [
          Row(
            spacing: 20.0,
            children: [_referentName(), _referentRole(), _referentCompany()],
          ),
          Row(spacing: 20.0, children: [_referentEmail(), _referentPhone()]),
          _SaveButton(() => _submit()),
        ],
      ),
    );
  }

  Expanded _referentName() {
    return Expanded(
      flex: 2,
      child: RequiredFormFieldWidget(
        controller: _nameController,
        label: "Nome referente(*)",
      ),
    );
  }

  Widget _referentCompany() {
    return Consumer(
      builder: (_, ref, __) {
        return Expanded(
          child: DropdownWidget(
            label: "Azienda a cui è associato(*)",
            items: ref
                .watch(referentCompanyOptionsProvider)
                .toDropdownItems((e) => e.companyRef.name),
            selectedValue: _referentCompanyController,
          ),
        );
      },
    );
  }

  Expanded _referentRole() {
    return Expanded(
      child: DropdownWidget(
        label: "Ruolo referente(*)",
        items: RoleType.values.toDropdownItems((e) => e.displayName),
        selectedValue: _roleController,
      ),
    );
  }

  Expanded _referentEmail() {
    return Expanded(
      child: RequiredFormFieldWidget(
        controller: _emailController,
        label: "Email referente(*)",
      ),
    );
  }

  Expanded _referentPhone() {
    return Expanded(
      child: FormFieldWidget(
        controller: _phoneController,
        label: "Numero di telefono referente",
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final referentsNotifier = ref.read(referentsProvider.notifier);

      final referentId = widget.referent?.jobApplicationReferent.referent.id;

      final referent = Referent(
        id: referentId,
        name: _nameController.text,
        role: _roleController.value,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        companyId: _referentCompanyController.value.companyRef.id,
      );

      final jobAppReferent = JobApplicationReferent(
        applicationId: ref.read(jobApplicationProvider).value?.id,
        referentAffiliation: _referentCompanyController.value.companyType,
        referent: referent,
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
    _referentCompanyController.value =
        ref.read(referentCompanyOptionsProvider).first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _referentCompanyController.dispose();

    super.dispose();
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
