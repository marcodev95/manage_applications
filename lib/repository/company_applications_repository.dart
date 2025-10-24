import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/job_application/job_application.dart';
import 'package:manage_applications/models/job_entry/job_entry_summary.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final companyApplicationsRepositoryProvider = Provider(
  (ref) => CompanyApplicationsRepository(DbHelper.instance),
);

class CompanyApplicationsRepository {
  final DbHelper _db;

  CompanyApplicationsRepository(final DbHelper db) : _db = db;

  Future<List<JobEntrySummary>> fetchApplicationsForClientCompany(
    int companyId,
  ) async {
    try {
      final sql = '''
      SELECT 
        ${JobApplicationsTableColumns.id}, 
        ${JobApplicationsTableColumns.position}, 
        ${JobApplicationsTableColumns.applyDate},
        ${JobApplicationsTableColumns.applicationStatus},
        
        ${JobApplicationsTableColumns.companyId},
        ${CompanyTableColumns.name} AS main

      FROM $jobApplicationsTable

      LEFT JOIN $companyTable 
      ON ${CompanyTableColumns.id} = ${JobApplicationsTableColumns.companyId}

      WHERE ${JobApplicationsTableColumns.clientCompanyId} = $companyId
    ''';

      final result = await _db.rawQuery(sql: sql);
      print(result);
      return List<JobEntrySummary>.from(
        result.map((e) => JobEntrySummary.fromJson(e)),
      );
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<List<JobEntrySummary>> fetchApplicationsForMainCompany(
    int companyId,
  ) async {
    try {
      final sql = '''
      SELECT 
        ${JobApplicationsTableColumns.id}, 
        ${JobApplicationsTableColumns.position}, 
        ${JobApplicationsTableColumns.applyDate}, 
        ${JobApplicationsTableColumns.applicationStatus},

        ${JobApplicationsTableColumns.clientCompanyId},
        ${CompanyTableColumns.name} AS client

      FROM $jobApplicationsTable 

      LEFT JOIN $companyTable 
      ON ${CompanyTableColumns.id} = ${JobApplicationsTableColumns.clientCompanyId}
      
      WHERE ${JobApplicationsTableColumns.companyId} = $companyId
    ''';

      final result = await _db.rawQuery(sql: sql);
      print('MAIN => $result');
      return List<JobEntrySummary>.from(
        result.map((e) => JobEntrySummary.fromJson(e)),
      );
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }
}
