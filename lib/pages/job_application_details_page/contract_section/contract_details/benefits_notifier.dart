import 'dart:async';

import 'package:manage_applications/models/contract/benefit.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contract_controller.dart';
import 'package:manage_applications/repository/benefit_repository.dart';
import 'package:riverpod/riverpod.dart';

class BenefitsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Benefit>, int?> {
  @override
  FutureOr<List<Benefit>> build(int? arg) async {
    final details = await ref.watch(getContractDetailsProvider(arg).future);

    return details.benefits;
  }

  Future<OperationResult> addBenefit(Benefit benefit) async {
    state = const AsyncLoading();

    try {
      final result = await _repository.addBenefit(benefit);

      state = AsyncData([...state.value!, result]);

      return Success(data: benefit, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> updateBenefit(Benefit benefit) async {
    final previousList = state.value ?? [];
    state = const AsyncLoading();

    try {
      await _repository.updateBenefit(benefit);

      final temp = [
        for (final el in previousList)
          if (el.id == benefit.id) benefit else el,
      ];

      state = AsyncData(temp);

      return Success(data: true, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> deleteBenefit(int id) async {
    state = const AsyncLoading();

    try {
      await _repository.deleteBenefit(id);

      state = AsyncData(
        state.value!.where((element) => element.id != id).toList(),
      );

      return Success(data: true, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      return mapToFailure(e, stackTrace);
    }
  }

  BenefitRepository get _repository => ref.read(benefitRepositoryProvider);
}

final benefitsProvider = AsyncNotifierProvider.autoDispose
    .family<BenefitsNotifier, List<Benefit>, int?>(BenefitsNotifier.new);
