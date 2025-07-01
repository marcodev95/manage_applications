import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/contract_details_page.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contract_delete_undo_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/are_job_application_id_and_company_id_present.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_table.dart';
import 'package:flutter/material.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class ContractSection extends StatelessWidget {
  const ContractSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionWidget(
      title: "Elenco contratti",
      trailing: Row(
        spacing: 20.0,
        children: [_GoToFormButton(), _RestoreLastDeletedContractButton()],
      ),
      body: SizedBox(
        height: 440.0,
        child: SingleChildScrollView(child: ContractTable()),
      ),
    );
  }
}

class _GoToFormButton extends ConsumerWidget {
  const _GoToFormButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(areJobApplicationIdAndCompanyIdPresent);

    return TextButtonWidget(
      onPressed:
          isActive
              ? () => navigatorPush(context, ContractDetailsPage())
              : () {},

      label: 'Nuovo Contratto',
      isEnable: isActive,
    );
  }
}

class _RestoreLastDeletedContractButton extends ConsumerWidget {
  const _RestoreLastDeletedContractButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLastDeletedContractEmpty =
        ref.watch(contractDeleteUndoProvider).value?.lastDeletedContract?.id ==
        null;

    return TextButtonWidget(
      onPressed:
          isLastDeletedContractEmpty ? () {} : () => _restore(ref, context),
      label: 'Ripristina contratto eliminato',
      isEnable: !isLastDeletedContractEmpty,
    );
  }

  void _restore(WidgetRef ref, BuildContext context) async {
    final contractsNotifier = ref.read(contractDeleteUndoProvider.notifier);

    final result = await contractsNotifier.restoreLastDeleteContract();

    if (!context.mounted) return;

    result.handleResult(context: context, ref: ref);
  }
}
