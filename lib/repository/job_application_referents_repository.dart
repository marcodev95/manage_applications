import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final jobApplicationReferentsRepositoryProvider = Provider(
  (_) => JobApplicationReferentsRepository(DbHelper.instance),
);

class JobApplicationReferentsRepository {
  final DbHelper _db;
  final tableName = JobApplicationReferentsColumns.tableName;

  JobApplicationReferentsRepository(final DbHelper db) : _db = db;

  Future<void> addReferentToJobApplication(
    int applicationId,
    JobApplicationReferent appReferent,
  ) async {
    try {
      await _db.create(
        table: tableName,
        json: appReferent.toJson(applicationId),
      );
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> unlinkCompanyReferentsFromJobApplication(
    int jobAppId,
    int companyId,
  ) async {
    try {
      final sql = '''
        DELETE FROM $tableName
        WHERE ${JobApplicationReferentsColumns.jobApplicationId} = ?
          AND ${JobApplicationReferentsColumns.referentId} IN (
          SELECT ${ReferentTableColumns.id} 
            FROM $referentTableName 
            WHERE ${ReferentTableColumns.companyId} = ?
          )
     ''';

      await _db.rawDelete(sql: sql, arguments: [jobAppId, companyId]);
    } catch (e, stackTrace) {
      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateJobApplicationReferent(
    int applicationId,
    JobApplicationReferent appReferent,
  ) async {
    try {
      final result = await _db.update(
        table: JobApplicationReferentsColumns.tableName,
        json: appReferent.toUpdatableJson(),
        where:
            '${JobApplicationReferentsColumns.jobApplicationId} = ? AND ${JobApplicationReferentsColumns.referentId} = ?',
        whereArgs: [applicationId, appReferent.referent.id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> unlinkReferentFromJobApplication(
    int appId,
    int referentId,
  ) async {
    try {
      final sql = ''' 
        DELETE FROM $tableName
        WHERE ${JobApplicationReferentsColumns.jobApplicationId} = ? 
          AND ${JobApplicationReferentsColumns.referentId} = ?
      ''';

      final result = await _db.rawDelete(
        sql: sql,
        arguments: [appId, referentId],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;
      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }
}
