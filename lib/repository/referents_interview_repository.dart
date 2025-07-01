import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/interview/referents_interview.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_details.dart';

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
          ${CompanyReferentTableColumns.id}, 
          ${CompanyReferentTableColumns.name},
          ${CompanyReferentTableColumns.email},
          ${CompanyReferentTableColumns.companyType},
          ${CompanyReferentTableColumns.role},

          ${ReferentsInterviewTableColumns.id}
      FROM $companyReferentTableName
        LEFT JOIN 
          $referentsInterviewTable 
            ON ${ReferentsInterviewTableColumns.referentId} = ${CompanyReferentTableColumns.id}
      WHERE ${ReferentsInterviewTableColumns.interviewId} = $id
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
    CompanyReferentUi referent,
  ) async {
    try {
      final lastId = await _db.create(
        table: referentsInterviewTable,
        json: SelectedReferentsForInterview.toJson(interviewId, referent.id!),
      );

      return Success<SelectedReferentsForInterview>(
        data: SelectedReferentsForInterview(id: lastId, referent: referent),
      );
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<OperationResult<void>> removeAssociate(int referentInterviewId) async {
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

      return Success(data: null);
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }

  /* Future<List<SelectedReferentsForInterview>> addMultipleReferentsToInterview(
    List<CompanyReferentUi> referents,
    int interviewId,
  ) async {
    final List<SelectedReferentsForInterview> tempList = [];

    final database = await _db.database;

    await database.transaction((txn) async {
      for (var referent in referents) {
        final lastId = await txn.insert(
          referentsInterviewTable,
          SelectedReferentsForInterview.toJson(interviewId, referent.id!),
        );

        tempList.add(
          SelectedReferentsForInterview(id: lastId, referent: referent),
        );
      }
    });

    return tempList;
  }

  Future<void> removeMultipleReferentsFromInterview(
    List<SelectedReferentsForInterview> allSelectedReferents,
  ) async {
    final database = await _db.database;

    await database.transaction((txn) async {
      for (var referentInterview in allSelectedReferents) {
        await txn.delete(
          referentsInterviewTable,
          where: '${ReferentsInterviewTableColumns.id} = ?',
          whereArgs: [referentInterview.id],
        );
      }
    });
  } */
}
