import 'package:manage_applications/models/db/db_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/job_data/job_application_ui.dart';
import 'package:manage_applications/models/job_data/job_data.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final companyApplicationsRepositoryProvider = Provider(
  (ref) => CompanyApplicationsRepository(DbHelper.instance),
);

class CompanyApplicationsRepository {
  final DbHelper _db;

  CompanyApplicationsRepository(final DbHelper db) : _db = db;

  Future<List<JobApplicationUi>> fetchApplicationsForClientCompany(
    int companyId,
  ) async {
    try {
      final sql = '''
      SELECT 
        ${JobDataTableColumns.id}, 
        ${JobDataTableColumns.position}, 
        ${JobDataTableColumns.applyDate},
        ${JobDataTableColumns.applicationStatus},
        ${JobDataTableColumns.websiteUrl}

      FROM $jobDataTable
      WHERE ${JobDataTableColumns.clientCompanyId} = $companyId
    ''';

      final result = await _db.rawQuery(sql: sql);
      return List<JobApplicationUi>.from(
        result.map((e) => JobApplicationUi.fromJson(e)),
      );
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<List<JobApplicationUi>> fetchApplicationsForMainCompany(
    int companyId,
  ) async {
    try {
      final sql = '''
      SELECT 
        ${JobDataTableColumns.id}, 
        ${JobDataTableColumns.position}, 
        ${JobDataTableColumns.applyDate},
        ${JobDataTableColumns.applicationStatus},
        ${JobDataTableColumns.websiteUrl}

      FROM $jobDataTable 
      WHERE ${JobDataTableColumns.companyId} = $companyId
    ''';

      final result = await _db.rawQuery(sql: sql);
      return List<JobApplicationUi>.from(
        result.map((e) => JobApplicationUi.fromJson(e)),
      );
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }
}
