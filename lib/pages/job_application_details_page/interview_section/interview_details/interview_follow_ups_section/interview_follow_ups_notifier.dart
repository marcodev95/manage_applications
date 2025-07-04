import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/provider/get_interview_details_provider.dart';
import 'package:manage_applications/repository/interview_follow_ups_repository.dart';

class InterviewFollowUpsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<InterviewFollowUp>, int?> {
  @override
  FutureOr<List<InterviewFollowUp>> build(int? arg) async {
    if (arg == null) return [];

    final details = await ref.watch(getInterviewDetailsProvider(arg).future);
    debugPrint('__Build_InterviewFollowUpsNotifier => ${details.followUps}');

    return details.followUps;
  }

  Future<void> createFollowUp(InterviewFollowUp followUp) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _repository.addFollowUp(followUp);

      return [..._currentState, result];
    });
  }

  Future<void> updateFollowUp(InterviewFollowUp followUp) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.updateFollowUp(followUp);

      return [
        for (final el in _currentState)
          if (el == followUp) followUp else el,
      ];
    });
  }

  Future<OperationResult> deleteFollowUp(InterviewFollowUp followUp) async {
    if (followUp.id == null) {
      throw MissingInformationError(
        error: 'ID_Follow-up non presente',
        stackTrace: StackTrace.current,
      );
    }

    state = const AsyncLoading();

    try {
      await _repository.deleteFollowUp(followUp.id!);

      state = AsyncData([
        for (final el in _currentState)
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
        error: 'ID_Colloquio non presente',
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

  List<InterviewFollowUp> get _currentState => state.value ?? [];
}

final interviewFollowUpsProvider = AsyncNotifierProvider.autoDispose
    .family<InterviewFollowUpsNotifier, List<InterviewFollowUp>, int?>(
      InterviewFollowUpsNotifier.new,
    );
