import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company_referent.dart';
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
    int jobApplicationId,
    int referentId,
  ) async {
    try {
      await _db.create(
        table: tableName,
        json: {
          JobApplicationReferentsColumns.jobApplicationId: jobApplicationId,
          JobApplicationReferentsColumns.referentId: referentId,
        },
      );
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> removeReferentToJobApplication(
    int jobApplicationId,
    int referentId,
  ) async {
    try {
      final result = await _db.delete(
        table: tableName,
        where:
            '${JobApplicationReferentsColumns.jobApplicationId} = ? AND ${JobApplicationReferentsColumns.referentId} = ?',
        whereArgs: [jobApplicationId, referentId],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> unlinkCompanyReferentsFromJobApplication(
    int jobAppId,
    int companyId,
  ) async {
    try {
      final sql = '''
        DELETE FROM $tableName
        WHERE ${JobApplicationReferentsColumns.jobApplicationId} = $jobAppId
          AND ${JobApplicationReferentsColumns.referentId} IN (
          SELECT ${CompanyReferentTableColumns.id} 
            FROM $companyReferentTableName 
            WHERE ${CompanyReferentTableColumns.companyId} = $companyId
          )
     ''';

      await _db.rawQuery(sql: sql);
    } catch (e, stackTrace) {
      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }
}
