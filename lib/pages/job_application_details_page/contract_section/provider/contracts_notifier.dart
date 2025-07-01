import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';

class ContractsNotifier extends AutoDisposeNotifier<List<ContractUI>> {
  @override
  List<ContractUI> build() {
    final contracts =
        ref.watch(fetchJobApplicationDetailsProvider).value?.contracts;

    return contracts ?? [];
  }

  void addContract(ContractUI contract) {
    state = [...state, contract];
  }

  void updateContract(ContractUI contract) {
    state = [
      for (final el in state)
        if (el == contract) contract else el,
    ];
  }

  void updateRAL(String ral, int id) {
    state = [
      for (final el in state)
        if (el.id == id) el.copyWith(ral: ral) else el,
    ];
  }

  void deleteContract(ContractUI contract) async {
    state = [
      for (final el in state)
        if (el != contract) el,
    ];
  }
}

final contractsProvider =
    AutoDisposeNotifierProvider<ContractsNotifier, List<ContractUI>>(
      ContractsNotifier.new,
    );
