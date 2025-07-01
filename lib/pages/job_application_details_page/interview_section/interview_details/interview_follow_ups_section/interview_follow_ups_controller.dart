import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/get_interview_details_provider.dart';
import 'package:manage_applications/repository/interview_follow_ups_repository.dart';

class InterviewFollowUpsController
    extends AutoDisposeFamilyAsyncNotifier<List<InterviewFollowUp>, int?> {
  @override
  FutureOr<List<InterviewFollowUp>> build(int? arg) async {
    if (arg == null) return [];

    final details = await ref.watch(getInterviewDetailsProvider(arg).future);
    debugPrint('__Build_InterviewFollowUpsController => ${details.followUps}');

    return details.followUps;
  }

  Future<void> createFollowUp(InterviewFollowUp followUp) async {
    final previousValue = state.valueOrNull ?? [];

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _repository.addFollowUp(followUp);

      return [...previousValue, result];
    });
  }

  Future<void> updateFollowUp(InterviewFollowUp followUp) async {
    final previousValue = state.valueOrNull ?? [];

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.updateFollowUp(followUp);

      return [
        for (final el in previousValue)
          if (el == followUp) followUp else el,
      ];
    });
  }

  Future<OperationResult> deleteFollowUp(InterviewFollowUp followUp) async {
    if (followUp.id == null) {
      throw MissingInformationError(
        error: 'ID del follow-up non presente',
        stackTrace: StackTrace.current,
      );
    }

    final previousValue = state.valueOrNull ?? [];

    state = const AsyncLoading();

    try {
      await _repository.deleteFollowUp(followUp.id!);

      state = AsyncData([
        for (final el in previousValue)
          if (el.id != followUp.id) el,
      ]);

      return Success(data: followUp, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return mapToFailure(e, stackTrace);
    }
  }

  Future<OperationResult> createOrUpdate(InterviewFollowUp followUp) async {
    if (followUp.interviewId == null) {
      return MissingInformationError(
        error: 'ID colloquio non presente',
        stackTrace: StackTrace.current,
      );
    }

    followUp.id == null
        ? await createFollowUp(followUp)
        : await updateFollowUp(followUp);

    if (state.hasError) {
      return mapToFailure(state.error!, state.stackTrace!);
    }

    return Success(data: null, message: SuccessMessage.saveMessage);
  }

  InterviewFollowUpsRepository get _repository =>
      ref.read(interviewFollowUpsRepositoryProvider);
}

final interviewFollowUpsController = AsyncNotifierProvider.autoDispose
    .family<InterviewFollowUpsController, List<InterviewFollowUp>, int?>(
      InterviewFollowUpsController.new,
    );
