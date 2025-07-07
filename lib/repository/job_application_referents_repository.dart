import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}
