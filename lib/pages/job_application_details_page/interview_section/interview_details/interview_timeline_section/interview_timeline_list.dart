import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/interview_timelines_provider.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';

import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class InterviewTimelineList extends ConsumerStatefulWidget {
  const InterviewTimelineList({super.key, this.routeID});

  final int? routeID;

  @override
  ConsumerState<InterviewTimelineList> createState() =>
      _InterviewTimelineListState();
}

class _InterviewTimelineListState extends ConsumerState<InterviewTimelineList> {
  @override
  Widget build(BuildContext context) {
    final asyncTimelines = ref.watch(
      interviewTimelinesProvider(widget.routeID),
    );

    return asyncTimelines.when(
      skipError: true,
      skipLoadingOnReload: true,
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
            onPressed:
                () => ref.invalidate(
                  interviewTimelinesProvider(widget.routeID),
                ),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _timelineCardWidget(InterviewTimeline timeline) {
    return switch (timeline.eventType) {
      InterviewStatus.completed => _DoneCardWidget(timeline),

      InterviewStatus.postponed => _PostponedCard(timeline),

      InterviewStatus.cancelled => _CancelledCardWidget(timeline),

      InterviewStatus.toDo => const SizedBox(),
    };
  }
}

class _DoneCardWidget extends StatelessWidget {
  const _DoneCardWidget(this.timeline);

  final InterviewTimeline timeline;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      externalPadding: EdgeInsets.symmetric(vertical: AppStyle.pad8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            spacing: 10.0,
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              _EventDateTimeBadge(convertDateTimeToUI(timeline.eventDateTime)),
              Text('- Colloquio svolto', style: TextStyle(fontSize: 16)),
            ],
          ),
          if (timeline.note != null && timeline.note!.isNotEmpty)
            _NoteWidget(timeline.note!),
        ],
      ),
    );
  }
}

class _PostponedCard extends StatelessWidget {
  const _PostponedCard(this.timeline);
  final InterviewTimeline timeline;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      externalPadding: EdgeInsets.symmetric(vertical: AppStyle.pad8),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10.0,
            children: [
              Icon(Icons.event_busy, color: Colors.amber),
              _EventDateTimeBadge(convertDateTimeToUI(timeline.eventDateTime)),
              Text('- Colloquio rinviato', style: TextStyle(fontSize: 16)),
            ],
          ),
          Text('Richiesto da: ${timeline.requester}'),
          Text('Da: ${convertDateTimeToUI(timeline.originalDateTime!)}'),
          Text('A: ${convertDateTimeToUI(timeline.newDateTime!)}'),
          Text('Motivo: ${timeline.reason}'),
          if (timeline.note != null && timeline.note!.isNotEmpty)
            _NoteWidget(timeline.note!),
        ],
      ),
    );
  }
}

class _CancelledCardWidget extends StatelessWidget {
  const _CancelledCardWidget(this.timeline);

  final InterviewTimeline timeline;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      externalPadding: EdgeInsets.symmetric(vertical: AppStyle.pad8),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10.0,
            children: [
              Icon(Icons.cancel, color: Colors.red),
              _EventDateTimeBadge(convertDateTimeToUI(timeline.eventDateTime)),
              Text('- Colloquio annullato', style: TextStyle(fontSize: 16)),
            ],
          ),
          Text('Richiesto da: ${timeline.requester}'),
          Text('Motivo: ${timeline.reason}'),

          if (timeline.note != null && timeline.note!.isNotEmpty)
            _NoteWidget(timeline.note!),
        ],
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

class _FollowUpSentCard extends StatelessWidget {
  const _FollowUpSentCard(this.timeline);

  final InterviewTimeline timeline;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      externalPadding: EdgeInsets.symmetric(vertical: AppStyle.pad8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            spacing: 10.0,
            children: [
              Icon(Icons.mail_outline, color: Colors.deepPurple[300]),
              _EventDateTimeBadge(
                dateTimeFormatUI.format(timeline.eventDateTime),
              ),
              Text('- FollowUp mandato', style: TextStyle(fontSize: 16)),
            ],
          ),
          Text(
            'Data e ora dell\'invio: ${convertDateTimeToUI(timeline.followUpSentAt!)}',
          ),
          Text('Invio a: ${timeline.followUpSentTo}'),
          if (timeline.note != null && timeline.note!.isNotEmpty)
            _NoteWidget(timeline.note!),
        ],
      ),
    );
  }
}
