import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/timeline/interview_timeline.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/provider/interview_timeline_events_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/provider/interview_timeline_follow_up_events_provider.dart';

class InterviewTimelinesNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<InterviewTimeline>, int?> {
  @override
  FutureOr<List<InterviewTimeline>> build(int? arg) async {
    final ie = await ref.watch(interviewEventsProvider(arg).future);
    final fe = await ref.watch(followUpEventsProvider(arg).future);
    final List<InterviewTimeline> allEvents = [...ie, ...fe];

    allEvents.sort((a, b) => a.eventDateTime.compareTo(b.eventDateTime));
    return allEvents;
  }
}

final interviewTimelinesProvider = AsyncNotifierProvider.autoDispose
    .family<InterviewTimelinesNotifier, List<InterviewTimeline>, int?>(
      InterviewTimelinesNotifier.new,
    );
