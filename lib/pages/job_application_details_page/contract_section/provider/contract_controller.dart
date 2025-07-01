import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/contract/benefit.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contracts_notifier.dart';
import 'package:manage_applications/repository/benefit_repository.dart';
import 'package:manage_applications/repository/contract_repository.dart';

final getContractDetailsProvider = FutureProvider.autoDispose
    .family<ContractDetails, int?>((ref, int? id) async {
      //final repository = ref.read(contractRepositoryProvider);
      final service = ref.read(contractServiceProvider);

      if (id == null) return ContractDetails.defaultValue();

      return await service.getContractDetails(id);
    });

class ContractController
    extends AutoDisposeFamilyAsyncNotifier<Contract, int?> {
  @override
  FutureOr<Contract> build(int? arg) async {
    final details = await ref.watch(getContractDetailsProvider(arg).future);

    return details.contract;
  }

  Future<void> createContract(Contract contract) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final lastId = await _repository.createContract(contract.toJson());

      _contractsNotifier.addContract(
        ContractUI(
          id: lastId,
          type: contract.type,
          contractDuration: contract.contractDuration,
          workPlaceAddress: contract.workPlaceAddress,
          isTrialContract: contract.isTrialContract,
          ral: contract.remuneration?.ral,
          jobApplicationId: contract.jobDataId,
        ),
      );

      return contract.copyWith(id: lastId);
    });

    debugPrint('__Dopo Update => $state');
  }

  Future<void> updateContract(Contract contract) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.updateContract(contract.toJson(), contract.id!);

      _contractsNotifier.updateContract(
        ContractUI(
          id: contract.id,
          type: contract.type,
          contractDuration: contract.contractDuration,
          isTrialContract: contract.isTrialContract,
          ral: contract.remuneration?.ral,
          workPlaceAddress: contract.workPlaceAddress,
          jobApplicationId: contract.jobDataId,
        ),
      );

      debugPrint('__Prima Update => $state');

      return contract.copyWith(remuneration: contract.remuneration);
    });
    debugPrint('__Dopo Update => $state');
  }

  Future<OperationResult> submit(Contract contract) async {
    final currentState = state.value;

    debugPrint('__CurrentState => $currentState');

    if (currentState == null) return _handleMissingInformation();

    currentState.id != null
        ? await updateContract(contract)
        : await createContract(contract);

    return _handleResult();
  }

  Failure _handleMissingInformation() {
    return Failure(
      error: MissingInformationError(),
      stackTrace: state.stackTrace,
      message:
          'Impossibile procedere. Alcune informazioni chiave sono mancanti.',
    );
  }

  OperationResult _handleResult() {
    if (state.hasError) {
      return Failure(
        error: state.error,
        stackTrace: state.stackTrace,
        message: 'Errore durante il salvataggio dei dati!',
      );
    }
    return Success<Contract?>(
      data: state.value,
      message: 'Eseguito con successo il salvataggio dei dati',
    );
  }

  ContractRepository get _repository => ref.read(contractRepositoryProvider);
  ContractsNotifier get _contractsNotifier =>
      ref.read(contractsProvider.notifier);
}

final contractController = AsyncNotifierProvider.autoDispose
    .family<ContractController, Contract, int?>(ContractController.new);

final contractServiceProvider = Provider(
  (ref) => ContractService(
    benefitRepository: ref.read(benefitRepositoryProvider),
    contractRepository: ref.read(contractRepositoryProvider),
  ),
);

class ContractService {
  final BenefitRepository benefitRepository;
  final ContractRepository contractRepository;

  ContractService({
    required this.benefitRepository,
    required this.contractRepository,
  });

  Future<ContractDetails> getContractDetails(int id) async {
    try {
      final contract = await contractRepository.getContract(id);

      final benefits = await benefitRepository.getAllBenefits(contract.id!);

      print(contract);

      print(benefits);

      return ContractDetails(contract: contract, benefits: benefits);
    } catch (e, stackTrace) {
      throw Failure(error: e, stackTrace: stackTrace);
    }
  }
}

class ContractDetails {
  final Contract contract;
  final List<Benefit> benefits;

  ContractDetails({required this.contract, this.benefits = const []});

  static ContractDetails defaultValue() {
    return ContractDetails(contract: Contract.initialValue(), benefits: []);
  }
}
