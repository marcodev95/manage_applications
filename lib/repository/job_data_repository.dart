import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/job_application/job_application_ui.dart';
import 'package:manage_applications/models/job_application/job_application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final jobApplicationRepositoryProvider = Provider(
  (ref) => JobApplicationRepository(DbHelper.instance),
);

class JobApplicationRepository {
  final DbHelper _db;
  final _table = jobApplicationsTable;

  JobApplicationRepository(DbHelper db) : _db = db;

  Future<List<JobApplication>> getAllJobApplications({
    List<String>? columns,
  }) async {
    final result = await _db.readAllItems(table: _table, columns: columns);

    return List.from(result.map((e) => JobApplication.fromJson(e)));
  }

  Future<List<JobApplicationUi>> fetchJobApplicationsWithCompany() async {
    final String sql = '''
    SELECT 
      jd.${JobApplicationsTableColumns.id}, 
      jd.${JobApplicationsTableColumns.applyDate}, 
      jd.${JobApplicationsTableColumns.position}, 
      jd.${JobApplicationsTableColumns.applicationStatus}, 
      jd.${JobApplicationsTableColumns.websiteUrl}, 
      jd.${JobApplicationsTableColumns.companyId},

      c.${CompanyTableColumns.id}, 
      c.${CompanyTableColumns.name}

      FROM $_table AS jd    
        LEFT JOIN $companyTable AS c 
          ON jd.${JobApplicationsTableColumns.companyId} = c.${CompanyTableColumns.id}
  ''';

    try {
      final result = await _db.rawQuery(sql: sql);

      return List<JobApplicationUi>.from(
        result.map((e) => JobApplicationUi.fromJson(e)),
      );
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<JobApplication> addJobApplication(
    JobApplication jobApplication,
  ) async {
    try {
      final lastId = await _db.create(
        table: _table,
        json: jobApplication.toJson(),
      );

      return jobApplication.copyWith(id: lastId);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateJobApplication(JobApplication jobApplication) async {
    try {
      final result = await _db.update(
        table: _table,
        json: jobApplication.toJson(),
        where: "${JobApplicationsTableColumns.id} = ?",
        whereArgs: [jobApplication.id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateCompanyId(int companyId, int jobAppId) async {
    try {
      final result = await _db.update(
        table: _table,
        json: {JobApplicationsTableColumns.companyId: companyId},
        where: "${JobApplicationsTableColumns.id} = ?",
        whereArgs: [jobAppId],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateClientCompanyId(int? companyId, int jobAppId) async {
    try {
      final result = await _db.update(
        table: _table,
        json: {JobApplicationsTableColumns.clientCompanyId: companyId},
        where: "${JobApplicationsTableColumns.id} = ?",
        whereArgs: [jobAppId],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteJobApplication(int id) async {
    try {
      final result = await _db.delete(
        table: _table,
        where: "${JobApplicationsTableColumns.id} = ?",
        whereArgs: [id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }

  Future<List<JobApplicationUi>> fetchJobApplicationsPage({
    required int itemsPerPage,
    required int offset,
    String? statusFilter,
  }) async {
    final whereClause =
        statusFilter != null
            ? 'WHERE jd.${JobApplicationsTableColumns.applicationStatus} = "$statusFilter"'
            : '';

    final sql = '''

      SELECT 
        jd.${JobApplicationsTableColumns.id}, 
        jd.${JobApplicationsTableColumns.applyDate}, 
        jd.${JobApplicationsTableColumns.position}, 
        jd.${JobApplicationsTableColumns.applicationStatus}, 
        jd.${JobApplicationsTableColumns.websiteUrl}, 
        jd.${JobApplicationsTableColumns.companyId},

        c.${CompanyTableColumns.id}, 
        c.${CompanyTableColumns.name}

      FROM $_table AS jd    
        LEFT JOIN $companyTable AS c 
          ON jd.${JobApplicationsTableColumns.companyId} = c.${CompanyTableColumns.id}
      
      $whereClause

      ORDER BY ${JobApplicationsTableColumns.id}

      LIMIT $itemsPerPage OFFSET $offset
    
    ''';

    try {
      final result = await _db.rawQuery(sql: sql);

      print('RESULT => $result');

      return List<JobApplicationUi>.from(
        result.map((e) => JobApplicationUi.fromJson(e)),
      );
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }
}
