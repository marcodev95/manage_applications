import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/timeline/interview_timeline.dart';
import 'package:manage_applications/models/timeline/timeline_event/follow_up_timeline_event.dart';
import 'package:manage_applications/models/timeline/timeline_event/interview_timeline_event.dart';

final interviewTimelineRepository = Provider(
  (_) => InterviewTimelineRepository(DbHelper.instance),
);

class InterviewTimelineRepository {
  InterviewTimelineRepository(final DbHelper dbHelper) : _db = dbHelper;

  final DbHelper _db;

  Future<InterviewTimelineEvent> addInterviewTimeline(
    InterviewTimelineEvent reschedule,
  ) async {
    try {
      final result = await _db.create(
        table: InterviewTimelineTable.tableName,
        json: reschedule.toJson(),
      );

      return reschedule.copyWith(id: result);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<FollowUpTimelineEvent> addFollowUpOnTimeline(
    FollowUpTimelineEvent event,
  ) async {
    try {
      final result = await _db.create(
        table: InterviewTimelineTable.tableName,
        json: event.toJson(),
      );

      return event.copyWith(id: result);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }
}
