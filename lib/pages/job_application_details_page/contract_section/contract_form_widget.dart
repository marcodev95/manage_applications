import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/contract/remuneration.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_form/contract_form_utlity.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_form/work_place_field.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contract_controller.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_form_controller.dart';
import 'package:manage_applications/widgets/components/dropdown_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class ContractFormWidget extends ConsumerStatefulWidget {
  const ContractFormWidget(this.contract, {super.key});

  final Contract? contract;

  @override
  ConsumerState<ContractFormWidget> createState() => _ContractFormWidgetState();
}

class _ContractFormWidgetState extends ConsumerState<ContractFormWidget>
    with AutomaticKeepAliveClientMixin<ContractFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = ValueNotifier<ContractsType>(ContractsType.definire);
  final _ccnlController = TextEditingController();
  final _notesController = TextEditingController();
  final _contractTrialController = ValueNotifier<bool>(false);
  final _durationController = TextEditingController();

  final _workingHoursController = TextEditingController();
  final _workingPlaceController = TextEditingController();
  final _workingPlaceNotifier = ValueNotifier<WorkPlace>(WorkPlace.remoto);

  final _salaryController = TextEditingController();
  final _ralController = TextEditingController();
  final _monthlyPaymentNumberController = TextEditingController();
  final _overTimeNotifier = ValueNotifier<bool>(false);
  final _productionBonusNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    if (widget.contract != null) {
      debugPrint('__InitState => ${widget.contract}');
      _initFormFields(widget.contract!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppStyle.pad16),
          child: Column(
            children: [
              _contractDetailsSection(),

              _workPlaceSection(),

              _remunerationSection(),

              Padding(
                padding: const EdgeInsets.all(AppStyle.pad16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _SaveButton(submit: () => submit()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contractDetailsSection() {
    return SectionWidget(
      title: 'Dettagli contratto',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30.0,
        children: [
          Row(
            spacing: 20.0,
            children: [
              Expanded(
                child: DropdownWidget<ContractsType>(
                  label: 'Tipo di contratto',
                  items: ContractsType.values.toDropdownItems(
                    (e) => e.displayName,
                  ),
                  selectedValue: _typeController,
                ),
              ),
              Expanded(
                child: FormFieldWidget(
                  controller: _ccnlController,
                  label: 'CCNL',
                ),
              ),
              Expanded(
                child: FormFieldWidget(
                  controller: _durationController,
                  label: "Durata del contratto",
                ),
              ),
            ],
          ),
          Row(
            spacing: 20.0,
            children: [
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _contractTrialController,
                  builder: (context, value, _) {
                    return SwitchListTile(
                      title: Text('Periodo di prova'),
                      value: value,
                      onChanged: (val) => _contractTrialController.value = val,
                    );
                  },
                ),
              ),
              Expanded(
                child: FormFieldWidget(
                  controller: _workingHoursController,
                  label: 'Ore lavorative',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          FormFieldWidget(
            controller: _notesController,
            label: 'Note aggiuntive',
            minLines: 6,
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }

  Widget _workPlaceSection() {
    return SectionWidget(
      externalPadding: const EdgeInsets.symmetric(horizontal: AppStyle.pad24),
      title: 'Luogo di lavoro',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30.0,
        children: [
          Row(
            spacing: 20.0,
            children: [
              Expanded(
                child: DropdownWidget<WorkPlace>(
                  label: 'Sede di lavoro',
                  items: WorkPlace.values.toDropdownItems((e) => e.displayName),
                  selectedValue: _workingPlaceNotifier,
                ),
              ),
              Expanded(
                flex: 2,
                child: WorkPlaceField(
                  controller: _workingPlaceController,
                  notifier: _workingPlaceNotifier,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _remunerationSection() {
    return SectionWidget(
      externalPadding: const EdgeInsets.all(AppStyle.pad24),
      title: 'Retribuzione',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30.0,
        children: [
          Row(
            spacing: 20.0,
            children: [
              Expanded(
                child: FormFieldWidget(
                  controller: _salaryController,
                  label: "Stipendio",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: FormFieldWidget(
                  controller: _ralController,
                  label: "RAL",
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*(\s*-\s*\d*)?$'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: FormFieldWidget(
                  controller: _monthlyPaymentNumberController,
                  label: "Numero mensilità",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _overTimeNotifier,
                  builder: (context, value, _) {
                    return SwitchListTile(
                      title: Text('Straordinari'),
                      value: value,
                      onChanged: (val) => _overTimeNotifier.value = val,
                    );
                  },
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _productionBonusNotifier,
                  builder: (context, value, _) {
                    return SwitchListTile(
                      title: Text('Premio di produzione'),
                      value: value,
                      onChanged: (val) => _productionBonusNotifier.value = val,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      final id = getRouteArg<int?>(context);
      final controller = ref.read(contractController(id).notifier);
      final result = await controller.submit(_contract(id));

      if (!mounted) return;

      result.handleResult(context: context, ref: ref);
    }
  }

  Contract _contract(int? id) {
    return Contract(
      id: ref.read(contractController(id)).value?.id,
      type: _typeController.value,
      contractDuration: _durationController.text,
      notes: _notesController.text,
      ccnl: _ccnlController.text,
      isTrialContract: _contractTrialController.value,
      workingHour: _workingHoursController.text,
      workPlace: _workingPlaceNotifier.value,
      workPlaceAddress: _workingPlaceController.text,
      remuneration: Remuneration(
        ral: _ralController.text,
        monthlyPayments: int.tryParse(_monthlyPaymentNumberController.text),
        monthlySalary: double.tryParse(_salaryController.text),
        isOvertimePresent: _overTimeNotifier.value,
        isProductionBonusPresent: _productionBonusNotifier.value,
      ),
      jobDataId: ref.read(jobDataFormController).value?.id
    );
  }

  void _initFormFields(Contract contract) {
    _typeController.value = contract.type;
    _ccnlController.text = contract.ccnl ?? '';
    _contractTrialController.value = contract.isTrialContract;
    _durationController.text = contract.contractDuration ?? '';

    _workingPlaceController.text = contract.workPlaceAddress ?? '';

    _workingPlaceNotifier.value = contract.workPlace;

    _notesController.text = contract.notes ?? '';
    _workingHoursController.text = contract.workingHour;

    final remuneration = contract.remuneration;

    _salaryController.text = "${remuneration?.monthlySalary ?? ''}";
    _monthlyPaymentNumberController.text =
        '${remuneration?.monthlyPayments ?? ''}';
    _ralController.text = remuneration?.ral ?? '';
    _overTimeNotifier.value = remuneration?.isOvertimePresent ?? false;
    _productionBonusNotifier.value =
        remuneration?.isProductionBonusPresent ?? false;
  }

  @override
  void dispose() {
    _typeController.dispose();
    _durationController.dispose();
    _salaryController.dispose();
    _ralController.dispose();
    _ccnlController.dispose();
    _notesController.dispose();
    _workingHoursController.dispose();
    _monthlyPaymentNumberController.dispose();
    _workingPlaceNotifier.dispose();
    _workingPlaceController.dispose();
    _overTimeNotifier.dispose();
    _productionBonusNotifier.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton({required this.submit});

  final VoidCallback submit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = getRouteArg<int?>(context);
    final controller = ref.watch(contractController(id));

    return controller.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SaveButtonWidget(onPressed: submit);
  }
}
