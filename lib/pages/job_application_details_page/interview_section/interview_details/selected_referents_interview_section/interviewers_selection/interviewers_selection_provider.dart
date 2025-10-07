import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/interview/referent_with_affiliation.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referents_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_table/selected_referents_interview_notifier.dart';

class InterviewersSelectionNotifer
    extends
        AutoDisposeFamilyAsyncNotifier<List<ReferentWithAffiliation>, int?> {
  @override
  FutureOr<List<ReferentWithAffiliation>> build(int? arg) async {
    final selected = await ref.watch(
      selectedReferentsForInterviewProvider(arg).future,
    );

    final allReferents = await ref.watch(referentsProvider.future);
    final filtered = allReferents.where(
      (r) =>
          !selected.any(
            (s) =>
                r.referentWithAffiliation.referent.id ==
                s.referentWithAffiliation.referent.id,
          ),
    );

    return filtered.map((e) => e.referentWithAffiliation).toList();
  }
}

final interviewersSelectionProvider = AsyncNotifierProvider.autoDispose
    .family<InterviewersSelectionNotifer, List<ReferentWithAffiliation>, int?>(
      InterviewersSelectionNotifer.new,
    );
