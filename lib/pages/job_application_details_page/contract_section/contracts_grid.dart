import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_card.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contracts_notifier.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class ContractsGrid extends ConsumerWidget {
  const ContractsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractsAsync = ref.watch(contractsProvider);

    return contractsAsync.when(
      skipError: true,
      skipLoadingOnReload: true,
      data: (contracts) => _ContractsGridBody(contracts),
      error: (_, __) {
        return DataLoadErrorScreenWidget(
          onPressed: () => ref.invalidate(contractsProvider),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ContractsGridBody extends ConsumerWidget {
  const _ContractsGridBody(this.contracts);

  final List<ContractUI> contracts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
      ),
      itemCount: contracts.length,
      itemBuilder: (_, int index) => ContractCard(contracts[index]),
    );
  }
}