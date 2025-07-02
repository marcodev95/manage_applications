import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/contract/benefit.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/benefits_section/benefits_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/provider/contract_form_provider.dart';
import 'package:manage_applications/widgets/components/button/save_button_widget.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';

class BenefitsForm extends ConsumerStatefulWidget {
  const BenefitsForm({super.key, this.benefit, this.routeArg});

  final Benefit? benefit;
  final int? routeArg;

  @override
  ConsumerState<BenefitsForm> createState() => _BenefitsFormState();
}

class _BenefitsFormState extends ConsumerState<BenefitsForm>
    with AutomaticKeepAliveClientMixin<BenefitsForm> {
  final _formKey = GlobalKey<FormState>();

  final benefitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.benefit != null) {
      benefitController.text = widget.benefit!.benefit;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: Row(
        spacing: 40.0,
        children: [
          Expanded(
            child: RequiredFormFieldWidget(
              controller: benefitController,
              label: 'Benefit',
            ),
          ),
          Consumer(
            builder: (_, ref, __) {
              final isContractIdNull = ref.watch(
                _isContractIdNullProvider(widget.routeArg),
              );
              return SaveButtonWidget(
                onPressed: isContractIdNull ? () {} : _submit,
                isEnable: !isContractIdNull,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(benefitsProvider(widget.routeArg).notifier);

      final contractId =
          ref.read(contractFormProvider(widget.routeArg)).value?.id;

      final benefit = Benefit(
        id: widget.benefit?.id,
        benefit: benefitController.text,
        contractId: contractId,
      );

      final submit =
          benefit.id == null
              ? await notifier.addBenefit(benefit)
              : await notifier.updateBenefit(benefit);

      if (!mounted) return;

      submit.handleResult(context: context, ref: ref);

      if (submit.isSuccess) benefitController.clear();

      if (benefit.id != null) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    benefitController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

final _isContractIdNullProvider = Provider.family.autoDispose(
  (ref, int? routeArg) => ref.watch(
    contractFormProvider(
      routeArg,
    ).select((value) => value.hasValue && value.value?.id == null),
  ),
);
