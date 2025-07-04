import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_monitoring_section/interview_timeline_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_monitoring_section/interview_timeline_utility.dart';

import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class InterviewTimelineList extends ConsumerWidget {
  const InterviewTimelineList({super.key, required this.onEdit});

  final void Function() onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeID = getRouteArg<int?>(context);

    final reschedulesAsync = ref.watch(interviewTimelineProvider(routeID));

    return reschedulesAsync.when(
      skipError: true,
      data: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, index) {
            final timeline = data[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _timelineCardWidget(timeline),
            );
          },
        );
      },
      error:
          (_, __) => DataLoadErrorScreenWidget(
            errorMessage: ErrorsMessage.dataLoading,
            onPressed: () => ref.invalidate(interviewTimelineProvider),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _timelineCardWidget(InterviewTimeline timeline) {
    return switch (timeline.eventType) {
      InterviewTimelineEvent.done => _DoneCardWidget(timeline),

      InterviewTimelineEvent.postponed => _PostponedCard(timeline),

      InterviewTimelineEvent.cancelled => _CancelledCardWidget(timeline),
      // TODO: Handle this case.
      InterviewTimelineEvent.relocated => SizedBox.shrink(),
      // TODO: Handle this case.
      InterviewTimelineEvent.reminderSent => SizedBox.shrink(),
    };
  }
}

class _DoneCardWidget extends StatelessWidget {
  const _DoneCardWidget(this.timeline);

  final InterviewTimeline timeline;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Row(
              spacing: 10.0,
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                _EventDateTimeBadge(timeline.eventDateTime),
                Text('- Colloquio svolto', style: TextStyle(fontSize: 16)),
              ],
            ),
            if (timeline.note != null && timeline.note!.isNotEmpty)
              _NoteWidget(timeline.note!),
          ],
        ),
      ),
    );
  }
}

class _PostponedCard extends StatelessWidget {
  const _PostponedCard(this.timeline);
  final InterviewTimeline timeline;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10.0,
              children: [
                Icon(Icons.event_busy, color: Colors.amber),
                _EventDateTimeBadge(timeline.eventDateTime),
                Text('- Colloquio rinviato', style: TextStyle(fontSize: 16)),
              ],
            ),
            Text('Richiesto da: ${timeline.requester}'),
            Text('Da: ${timeline.originalDateTime}'),
            Text('A: ${timeline.newDateTime}'),
            Text('Motivo: ${timeline.reason}'),
            if (timeline.note != null && timeline.note!.isNotEmpty)
              _NoteWidget(timeline.note!),
          ],
        ),
      ),
    );
  }
}

class _CancelledCardWidget extends StatelessWidget {
  const _CancelledCardWidget(this.timeline);

  final InterviewTimeline timeline;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10.0,
              children: [
                Icon(Icons.cancel, color: Colors.red),
                _EventDateTimeBadge(timeline.eventDateTime),
                Text('- Colloquio annullato', style: TextStyle(fontSize: 16)),
              ],
            ),
            Text('Richiesto da: ${timeline.requester}'),
            Text('Motivo: ${timeline.reason}'),

            if (timeline.note != null && timeline.note!.isNotEmpty)
              _NoteWidget(timeline.note!),
          ],
        ),
      ),
    );
  }
}

class _EventDateTimeBadge extends StatelessWidget {
  const _EventDateTimeBadge(this.eventDateTime);

  final String eventDateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        eventDateTime,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _NoteWidget extends StatelessWidget {
  const _NoteWidget(this.note);

  final String note;

  @override
  Widget build(BuildContext context) {
    return Text(
      note,
      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
    );
  }
}
