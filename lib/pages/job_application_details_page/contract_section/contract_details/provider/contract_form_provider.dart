import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/provider/get_contract_details_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contracts_notifier.dart';
import 'package:manage_applications/repository/contract_repository.dart';

class ContractFormNotifier
    extends AutoDisposeFamilyAsyncNotifier<Contract, int?> {
  @override
  FutureOr<Contract> build(int? arg) async {
    final details = await ref.watch(getContractDetailsProvider(arg).future);

    return details.contract;
  }

  Future<void> createContract(Contract contract) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _repository.createContract(contract);

      _contractsNotifier.addContract(
        result.toUI(
          ral: contract.remuneration?.ral,
          jobDataId: contract.jobDataId,
        ),
      );

      return contract.copyWith(id: result.id);
    });

    debugPrint('__Dopo Create => $state');
  }

  Future<void> updateContract(Contract contract) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.updateContract(contract);

      _contractsNotifier.updateContract(
        contract.toUI(
          ral: contract.remuneration?.ral,
          jobDataId: contract.jobDataId,
        ),
      );

      debugPrint('__Prima Update => $state');

      return contract.copyWith(remuneration: contract.remuneration);
    });
    debugPrint('__Dopo Update => $state');
  }

  Future<OperationResult> submit(Contract contract) async {
    final currentState = state.value;

    if (currentState == null) {
      state = AsyncValue.error(MissingInformationError(), StackTrace.current);
      return MissingInformationError();
    }

    currentState.id != null
        ? await updateContract(contract)
        : await createContract(contract);

    return _handleResult();
  }

  OperationResult<Contract?> _handleResult() {
    if (state.hasError) {
      return SaveError(error: state.error);
    }
    return Success(data: state.value, message: SuccessMessage.saveMessage);
  }

  ContractRepository get _repository => ref.read(contractRepositoryProvider);
  ContractsNotifier get _contractsNotifier =>
      ref.read(contractsProvider.notifier);
}

final contractFormProvider = AsyncNotifierProvider.autoDispose
    .family<ContractFormNotifier, Contract, int?>(ContractFormNotifier.new);
