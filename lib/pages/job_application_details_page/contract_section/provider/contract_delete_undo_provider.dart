import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contracts_notifier.dart';
import 'package:manage_applications/repository/contract_repository.dart';

class ContractDeleteUndoNotifier
    extends AutoDisposeAsyncNotifier<ContractActionsState> {
  @override
  FutureOr<ContractActionsState> build() {
    return ContractActionsState();
  }

  Future<OperationResult> deleteContract(ContractUI contract) async {
    final repository = ref.read(contractRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final tempContract = await repository.getContract(contract.id!);
      await repository.deleteContract(contract.id!);

      ref.read(contractsProvider.notifier).deleteContract(contract);

      return ContractActionsState(lastDeletedContract: tempContract);
    });

    if (state.hasError) {
      return Failure(
        error: state.error,
        message: 'Errore durante il l\'eliminazione del contratto',
        stackTrace: state.stackTrace,
      );
    }

    return Success(
      data: null,
      message: 'Eseguito con successo l\'eliminazione del contratto',
    );
  }

  Future<OperationResult> restoreLastDeleteContract() async {
    final repository = ref.read(contractRepositoryProvider);
    final contractsNotifier = ref.read(contractsProvider.notifier);

    state = const AsyncLoading();

    final lastDeletedContract = state.value?.lastDeletedContract;

    if (lastDeletedContract == null) {
      return Failure(
        error: MissingInformationError(),
        stackTrace: StackTrace.current,
        message: 'Errore durante il recupero di informazioni chaive',
      );
    }

    debugPrint('__LastDeleted => $lastDeletedContract');

    state = await AsyncValue.guard(() async {
      final result = await repository.createContract(
        lastDeletedContract,
      );

      contractsNotifier.addContract(
        ContractUI(
          id: result.id,
          type: lastDeletedContract.type,
          contractDuration: lastDeletedContract.contractDuration,
          isTrialContract: lastDeletedContract.isTrialContract,
          ral: lastDeletedContract.remuneration?.ral,
          workPlaceAddress: lastDeletedContract.workPlaceAddress,
          jobApplicationId: lastDeletedContract.jobApplicationId,
        ),
      );

      return ContractActionsState();
    });

    if (state.hasError) {
      return Failure(
        error: state.error,
        message: 'Errore durante il ripristino del contratto eliminato',
        stackTrace: state.stackTrace,
      );
    }

    return Success(
      data: null,
      message: 'Eseguito con successo il ripristino del contratto eliminato',
    );
  }
}

final contractDeleteUndoProvider = AutoDisposeAsyncNotifierProvider<
  ContractDeleteUndoNotifier,
  ContractActionsState
>(ContractDeleteUndoNotifier.new);

class ContractActionsState {
  Contract? lastDeletedContract;

  ContractActionsState({this.lastDeletedContract});
}
