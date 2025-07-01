import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/contract_details_page.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_form/contract_form_utlity.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contracts_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contract_delete_undo_notifier.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class ContractTable extends ConsumerWidget {
  const ContractTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contracts = ref.watch(contractsProvider);

    return TableWidget(
      columns: [
        dataColumnWidget('Tipo'),
        dataColumnWidget('Durata'),
        dataColumnWidget('Prova'),
        dataColumnWidget('RAL'),
        dataColumnWidget('Sede di lavoro'),
        dataColumnWidget('Azioni'),
      ],
      dataRow: buildColoredRow(
        list: contracts,
        cells: (contract, _) {
          return [
            DataCell(
              Text(
                contract.type.displayName,
                style: TextStyle(fontSize: AppStyle.tableTextFontSize),
              ),
            ),
            DataCell(
              SizedBox(
                width: 100.0,
                child: Tooltip(
                  message: contract.contractDuration ?? '',
                  child: TextOverflowEllipsisWidget(
                    contract.contractDuration ?? '',
                  ),
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 30.0,
                child: Text(
                  contract.trialContractLabel,
                  style: TextStyle(fontSize: AppStyle.tableTextFontSize),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 150.0,
                child: Text(
                  contract.ral ?? '',
                  style: TextStyle(fontSize: AppStyle.tableTextFontSize),
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 200.0,
                child: Tooltip(
                  message: contract.workPlaceAddress,
                  child: TextOverflowEllipsisWidget(
                    contract.workPlaceAddress ?? '',
                  ),
                ),
              ),
            ),
            DataCell(
              TableButtonsWidget(
                buttons: [
                  EditContractButtonWidget(contract.id!),
                  RemoveContractButtonWidget(contract: contract),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}

class EditContractButtonWidget extends ConsumerWidget {
  const EditContractButtonWidget(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        navigatorPush(
          context,
          ContractDetailsPage(),
          RouteSettings(arguments: id),
        );
      },
      icon: const Icon(Icons.edit, color: Colors.amber),
    );
  }
}

class RemoveContractButtonWidget extends ConsumerWidget {
  const RemoveContractButtonWidget({super.key, required this.contract});

  final ContractUI contract;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(contractDeleteUndoProvider).isLoading;

    return isLoading
        ? CircularProgressIndicator()
        : IconButton(
          onPressed: isLoading ? () {} : () => _delete(ref, context),
          icon: Icon(Icons.delete, color: Colors.red),
        );
  }

  void _delete(WidgetRef ref, BuildContext context) async {
    final controller = ref.read(contractDeleteUndoProvider.notifier);
    final result = await controller.deleteContract(contract);

    if (!context.mounted) return;

    result.handleErrorResult(context: context, ref: ref);
  }
}
