import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';

class ContractsNotifier extends AutoDisposeAsyncNotifier<List<ContractUI>> {
  @override
  FutureOr<List<ContractUI>> build() async {
    final details = await ref.watch(fetchJobApplicationDetailsProvider.future);

    return details.contracts;
  }

  void addContract(ContractUI contract) {
    state = state.whenData((value) => [...value, contract]);
  }

  void updateContract(ContractUI contract) {
    state = state.whenData((value) {
      return [
        for (final el in value)
          if (el == contract) contract else el,
      ];
    });
  }

  void updateRAL(int ral, int id) {
    state = state.whenData((value) {
      return [
        for (final el in value)
          if (el.id == id) el.copyWith(ral: ral) else el,
      ];
    });
  }

  void deleteContract(ContractUI contract) async {
    state = state.whenData((value) {
      return [
        for (final el in value)
          if (el != contract) el,
      ];
    });
  }
}

final contractsProvider =
    AutoDisposeAsyncNotifierProvider<ContractsNotifier, List<ContractUI>>(
      ContractsNotifier.new,
    );
