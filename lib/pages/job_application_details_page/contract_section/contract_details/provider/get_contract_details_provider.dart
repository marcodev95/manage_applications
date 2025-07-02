import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/contract/benefit.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/repository/benefit_repository.dart';
import 'package:manage_applications/repository/contract_repository.dart';

final getContractDetailsProvider = FutureProvider.autoDispose
    .family<ContractDetails, int?>((ref, int? id) async {
      final service = ref.read(contractServiceProvider);

      if (id == null) return ContractDetails.defaultValue();

      return await service.getContractDetails(id);
    });

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

      return ContractDetails(contract: contract, benefits: benefits);
    } catch (e, stackTrace) {
      throw ItemNotFound(error: e, stackTrace: stackTrace);
    }
  }
}

class ContractDetails {
  final Contract contract;
  final List<Benefit> benefits;

  const ContractDetails({required this.contract, this.benefits = const []});

  static ContractDetails defaultValue() {
    return ContractDetails(contract: Contract.initialValue(), benefits: []);
  }
}
