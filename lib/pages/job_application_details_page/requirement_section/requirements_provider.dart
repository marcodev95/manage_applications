import 'dart:async';

import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/requirement.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/repository/requirement_repository.dart';
import 'package:riverpod/riverpod.dart';

class RequirementsNotifier extends AutoDisposeAsyncNotifier<List<Requirement>> {
  @override
  FutureOr<List<Requirement>> build() async {
    final details = await ref.watch(fetchJobApplicationDetailsProvider.future);

    return details.requirements;
  }

  Future<OperationResult> addRequirement(Requirement requirement) async {
    state = const AsyncLoading();

    try {
      final lastInserted = await _repository.addRequirement(requirement);
      state = AsyncData([..._currentRequirements, lastInserted]);

      return Success<bool>(data: true, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> updateRequirement(Requirement requirement) async {
    state = const AsyncLoading();

    try {
      await _repository.updateRequirement(requirement);

      final updateList =
          _currentRequirements
              .map((e) => e.id == requirement.id ? requirement : e)
              .toList();
      state = AsyncData(updateList);

      return Success(data: requirement, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> deleteRequirement(int id) async {
    state = const AsyncLoading();

    try {
      await _repository.deleteRequirement(id);

      final updateList =
          _currentRequirements.where((element) => element.id != id).toList();

      state = AsyncData(updateList);

      return Success(data: true, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  RequirementRepository get _repository => ref.read(requirementRepository);

  List<Requirement> get _currentRequirements => state.value ?? [];
}

final requirementsProvider =
    AutoDisposeAsyncNotifierProvider<RequirementsNotifier, List<Requirement>>(
      RequirementsNotifier.new,
    );
