import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/job_data/job_application_ui.dart';
import 'package:manage_applications/models/job_data/job_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final jobDataRepositoryProvider = Provider(
  (ref) => JobDataRepository(DbHelper.instance),
);

class JobDataRepository {
  final DbHelper _db;
  final _table = jobDataTable;

  JobDataRepository(DbHelper db) : _db = db;

  Future<List<JobData>> getAllJobData({List<String>? columns}) async {
    final result = await _db.readAllItems(table: _table, columns: columns);

    return List.from(result.map((e) => JobData.fromJson(e)));
  }

  Future<List<JobApplicationUi>> fetchJobApplicationsWithCompany() async {
    final String sql = '''
    SELECT 
      jd.${JobDataTableColumns.id}, 
      jd.${JobDataTableColumns.applyDate}, 
      jd.${JobDataTableColumns.position}, 
      jd.${JobDataTableColumns.applicationStatus}, 
      jd.${JobDataTableColumns.websiteUrl}, 
      jd.${JobDataTableColumns.companyId},

      c.${CompanyTableColumns.id}, 
      c.${CompanyTableColumns.name}

      FROM $jobDataTable AS jd    
        LEFT JOIN $companyTable AS c 
          ON jd.${JobDataTableColumns.companyId} = c.${CompanyTableColumns.id}
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

  Future<JobData> addJobData(JobData jobData) async {
    try {
      final lastId = await _db.create(table: _table, json: jobData.toJson());

      return jobData.copyWith(id: lastId);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateJobData(JobData jobData) async {
    try {
      final result = await _db.update(
        table: _table,
        json: jobData.toJson(),
        where: "${JobDataTableColumns.id} = ?",
        whereArgs: [jobData.id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateCompanyId(int companyId, int jobDataId) async {
    try {
      final result = await _db.update(
        table: _table,
        json: {JobDataTableColumns.companyId: companyId},
        where: "${JobDataTableColumns.id} = ?",
        whereArgs: [jobDataId],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateClientCompanyId(int? companyId, int jobDataId) async {
    try {
      final result = await _db.update(
        table: _table,
        json: {JobDataTableColumns.clientCompanyId: companyId},
        where: "${JobDataTableColumns.id} = ?",
        whereArgs: [jobDataId],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteJobData(int id) async {
    try {
      final result = await _db.delete(
        table: _table,
        where: "${JobDataTableColumns.id} = ?",
        whereArgs: [id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }

  Future<List<JobApplicationUi>> paginatorQuery({
    required int itemsPerPage,
    required int offset,
    String? statusFilter,
  }) async {
    final whereClause =
        statusFilter != null
            ? 'WHERE jd.${JobDataTableColumns.applicationStatus} = "$statusFilter"'
            : '';

    final sql = '''

      SELECT 
        jd.${JobDataTableColumns.id}, 
        jd.${JobDataTableColumns.applyDate}, 
        jd.${JobDataTableColumns.position}, 
        jd.${JobDataTableColumns.applicationStatus}, 
        jd.${JobDataTableColumns.websiteUrl}, 
        jd.${JobDataTableColumns.companyId},

        c.${CompanyTableColumns.id}, 
        c.${CompanyTableColumns.name}

      FROM $jobDataTable AS jd    
        LEFT JOIN $companyTable AS c 
          ON jd.${JobDataTableColumns.companyId} = c.${CompanyTableColumns.id}
      
      $whereClause

      ORDER BY ${JobDataTableColumns.id}

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
