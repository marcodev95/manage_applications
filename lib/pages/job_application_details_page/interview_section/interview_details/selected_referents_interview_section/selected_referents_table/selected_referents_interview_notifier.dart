import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/interview/referents_interview.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/provider/get_interview_details_provider.dart';
import 'package:manage_applications/repository/referents_interview_repository.dart';

class SelectedReferentsForInterviewNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<
          List<SelectedReferentsForInterview>,
          int?
        > {
  @override
  FutureOr<List<SelectedReferentsForInterview>> build(int? arg) async {
    if (arg == null) return [];

    final result = await ref.watch(getInterviewDetailsProvider(arg).future);
    return result.referents;
  }

  ReferentsInterviewRepository get _repository =>
      ref.read(referentsInterviewRepository);

  Future<void> addReferent(JobApplicationReferent referent) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final interviewId = ref.read(interviewFormProvider(arg)).value?.id;

      if (interviewId == null || referent.referent.id == null) {
        throw MissingInformationError(stackTrace: StackTrace.current);
      }

      final previousValue = state.valueOrNull ?? [];

      final result = await _repository.associate(interviewId, referent);

      return [...previousValue, result.data];
    });

    debugPrint('__State => $state');
  }

  Future<void> removeReferent(int? id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      if (id == null) {
        throw MissingInformationError(stackTrace: StackTrace.current);
      }

      final previousValue = state.valueOrNull ?? [];

      await _repository.removeAssociate(id);

      return previousValue.where((element) => element.id != id).toList();
    });
    debugPrint('__Delete__State => $state');
  }
}

final selectedReferentsForInterviewProvider = AsyncNotifierProvider.autoDispose
    .family<
      SelectedReferentsForInterviewNotifier,
      List<SelectedReferentsForInterview>,
      int?
    >(SelectedReferentsForInterviewNotifier.new);
