import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/interview/interview_details.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/interview/referents_interview.dart';
import 'package:manage_applications/models/job_application/job_application_referent.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/timeline/interview_timeline.dart';

final referentsInterviewRepository = Provider(
  (_) => ReferentsInterviewRepository(DbHelper.instance),
);

class ReferentsInterviewRepository {
  final DbHelper _db;

  ReferentsInterviewRepository(final DbHelper db) : _db = db;

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

      debugPrint('__RESULT => $map');

      return Success(data: InterviewDetails.fromJson(map));
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<OperationResult<SelectedReferentsForInterview>> associate(
    int interviewId,
    JobApplicationReferent referent,
  ) async {
    try {
      final lastId = await _db.create(
        table: referentsInterviewTable,
        json: SelectedReferentsForInterview.toJson(
          interviewId,
          referent.referent.id!,
        ),
      );

      return Success<SelectedReferentsForInterview>(
        data: SelectedReferentsForInterview(
          id: lastId,
          referent: JobApplicationReferent(
            referentAffiliation: referent.referentAffiliation,
            referent: referent.referent,
          ),
        ),
      );
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<OperationResult<bool>> removeAssociate(int referentInterviewId) async {
    try {
      final result = await _db.delete(
        table: referentsInterviewTable,
        where: '${ReferentsInterviewTableColumns.id} = ?',
        whereArgs: [referentInterviewId],
      );

      //Necessario perchè delete non da errore se non trova corrispondenza
      if (result == 0) {
        throw ItemNotFound(stackTrace: StackTrace.current);
      }

      return Success(data: true);
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }
}
