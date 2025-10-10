import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/interview/interview_details.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/interview/selected_referent_for_interview.dart';
import 'package:manage_applications/models/job_application/job_application_referent.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/timeline/interview_timeline.dart';

final interviewRepository = Provider(
  (_) => InterviewRepository(DbHelper.instance),
);

class InterviewRepository {
  InterviewRepository(final DbHelper dbHelper) : _db = dbHelper;

  final DbHelper _db;

  Future<OperationResult<InterviewDetails>> getInterviewDetails(int id) async {
    try {
      final interviewQuery = ''' 
      SELECT $interviewTable.*   
      FROM $interviewTable  
      WHERE ${InterviewTableColumns.id} = $id
    ''';

      final interview = await _db.rawQueryReadSingleItem(sql: interviewQuery);

      final followUpQuery = ''' 
      SELECT $interviewFollowUpTable.*    
      FROM $interviewFollowUpTable  
      WHERE ${InterviewFollowUpColumns.interviewId} = $id
    ''';

      final followUps = await _db.rawQuery(sql: followUpQuery);

      final referents = await _getReferentsInterview(id);

      final timelineQuery = ''' 
        SELECT ${InterviewTimelineTable.tableName}.* 
        FROM ${InterviewTimelineTable.tableName}
        WHERE ${InterviewTimelineTable.interviewId} = $id
      ''';

      final timeline = await _db.rawQuery(sql: timelineQuery);

      final Map<String, dynamic> map = {
        'interview': interview,
        'follow_ups': followUps,
        'referents': referents,
        'timeline': timeline,
      };

      debugPrint('__REF.INT.REPO.RESULT => $map');

      return Success(data: InterviewDetails.fromJson(map));
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<List<Map<String, Object?>>> _getReferentsInterview(int id) async {
    try {
      final referentsQuery = '''
      SELECT 
          cr.${ReferentTableColumns.id}, 
          cr.${ReferentTableColumns.name},
          cr.${ReferentTableColumns.email},
          cr.${ReferentTableColumns.role},

          ri.${ReferentsInterviewTableColumns.id},

          jar.${JobApplicationReferentsColumns.referentAffiliation}

      FROM $referentTableName AS cr

      INNER JOIN $referentsInterviewTable AS ri
        ON ri.${ReferentsInterviewTableColumns.referentId} = cr.${ReferentTableColumns.id}
        AND ri.${ReferentsInterviewTableColumns.interviewId} = $id

      LEFT JOIN ${JobApplicationReferentsColumns.tableName} AS jar
        ON jar.${JobApplicationReferentsColumns.referentId} = cr.${ReferentTableColumns.id}
    ''';

      final referents = await _db.rawQuery(sql: referentsQuery);

      return referents;
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<Interview> addInterview(Interview interview) async {
    try {
      final result = await _db.create(
        table: interviewTable,
        json: interview.toJson(),
      );

      return interview.copyWith(id: result);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateInterview(Interview interview) async {
    try {
      final result = await _db.update(
        table: interviewTable,
        json: interview.toJson(),
        where: "${InterviewTableColumns.id} = ?",
        whereArgs: [interview.id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteInterview(int id) async {
    try {
      final result = await _db.delete(
        table: interviewTable,
        where: "${InterviewTableColumns.id} = ?",
        whereArgs: [id],
      );

      if (result == 0) throw ItemNotFound(stackTrace: StackTrace.current);
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateInterviewStatus(int id, String status) async {
    try {
      final result = await _db.update(
        table: interviewTable,
        json: {InterviewTableColumns.status: status},
        where: "${InterviewTableColumns.id} = ?",
        whereArgs: [id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateReschedulePlace(
    int id,
    String oldPlace,
    String newPlace,
  ) async {
    try {
      final result = await _db.update(
        table: interviewTable,
        json: {
          InterviewTableColumns.placeUpdated: 1,
          InterviewTableColumns.previousInterviewPlace: oldPlace,
          InterviewTableColumns.interviewPlace: newPlace,
        },
        where: "${InterviewTableColumns.id} = ?",
        whereArgs: [id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }
}
