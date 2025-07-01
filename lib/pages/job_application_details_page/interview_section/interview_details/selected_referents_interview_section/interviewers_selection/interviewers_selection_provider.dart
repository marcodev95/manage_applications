import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referents_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_table/selected_referents_interview_notifier.dart';

class InterviewersSelectionNotifer
    extends AutoDisposeFamilyAsyncNotifier<List<CompanyReferentUi>, int?> {
  @override
  FutureOr<List<CompanyReferentUi>> build(int? arg) async {
    final selected = await ref.watch(
      selectedReferentsForInterviewProvider(arg).future,
    );

    final allReferents = await ref.watch(companyReferentsProvider.future);

    final filter =
        allReferents
            .where(
              (referent) =>
                  !selected.any(
                    (selectedRefent) =>
                        referent.id == selectedRefent.referent.id,
                  ),
            )
            .toList();

    return filter;
  }
}

final interviewersSelectionProvider = AsyncNotifierProvider.autoDispose
    .family<InterviewersSelectionNotifer, List<CompanyReferentUi>, int?>(
      InterviewersSelectionNotifer.new,
    );
