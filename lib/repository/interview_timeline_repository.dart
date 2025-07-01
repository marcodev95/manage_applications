import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final interviewTimelineRepository = Provider(
  (_) => InterviewTimelineRepository(DbHelper.instance),
);

class InterviewTimelineRepository {
  InterviewTimelineRepository(final DbHelper dbHelper) : _db = dbHelper;

  final DbHelper _db;

  Future<InterviewTimeline> addInterviewTimeline(
    InterviewTimeline reschedule,
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
}
