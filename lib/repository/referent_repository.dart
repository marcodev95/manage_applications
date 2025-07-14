import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/referent/referent_details.dart';
import 'package:manage_applications/models/referent/referent_with_company.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final referentRepositoryProvider = Provider(
  (_) => ReferentRepository(DbHelper.instance),
);

class ReferentRepository {
  final DbHelper _db;

  ReferentRepository(DbHelper db) : _db = db;

  Future<List<ReferentWithCompany>> getAvailableCompanyReferents(
    int mainId,
    int applicationId,
    int? clientId,
  ) async {
    try {
      final companyIds = [mainId, clientId].whereType<int>().toList();
      final placeholders = List.filled(companyIds.length, '?').join(', ');

      final sql = '''
        SELECT 
          r.${ReferentTableColumns.id},
          r.${ReferentTableColumns.name},
          r.${ReferentTableColumns.email},
          r.${ReferentTableColumns.role},

          c.${CompanyTableColumns.id},
          c.${CompanyTableColumns.name} AS c_name

          FROM $referentTableName AS r
            INNER JOIN $companyTable AS c
              ON r.${ReferentTableColumns.companyId} = c.${CompanyTableColumns.id}
          
          WHERE r.${ReferentTableColumns.companyId} IN ($placeholders) 
            AND r.${ReferentTableColumns.id} NOT IN (
              SELECT ${JobApplicationReferentsColumns.referentId} 
              FROM ${JobApplicationReferentsColumns.tableName} 
              WHERE ${JobApplicationReferentsColumns.jobApplicationId} = ?
            )

          ORDER BY c.${CompanyTableColumns.id} ASC
      ''';

      final result = await _db.rawQuery(
        sql: sql,
        arguments: [...companyIds, applicationId],
      );

      return List.from(result.map((e) => ReferentWithCompany.fromJson(e)));
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<Referent> addReferent(Referent referent) async {
    try {
      final lastId = await _db.create(
        table: referentTableName,
        json: referent.toJson(),
      );

      return referent.copyWith(id: lastId);
    } catch (e, stackTrace) {
      if (e is MissingInformationError) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateReferent(Referent referent) async {
    try {
      final result = await _db.update(
        table: referentTableName,
        json: referent.toJson(),
        where: "${ReferentTableColumns.id} = ?",
        whereArgs: [referent.id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<ReferentDetails> getReferentDetails(
    int applicationId,
    int referentId,
  ) async {
    try {
      final sql = '''
    SELECT 
      r.${ReferentTableColumns.id},
      r.${ReferentTableColumns.name},
      r.${ReferentTableColumns.role},
      r.${ReferentTableColumns.email},
      r.${ReferentTableColumns.phoneNumber},
      r.${ReferentTableColumns.companyId},

      c.${CompanyTableColumns.id} AS company_id,
      c.${CompanyTableColumns.name} AS company_name,

      jar.${JobApplicationReferentsColumns.referentAffiliation},
      jar.${JobApplicationReferentsColumns.involvedInInterview}


    FROM ${JobApplicationReferentsColumns.tableName} AS jar
      INNER JOIN $referentTableName AS r 
        ON jar.${JobApplicationReferentsColumns.referentId} = r.${ReferentTableColumns.id}
      INNER JOIN $companyTable AS c 
        ON r.${ReferentTableColumns.companyId} = c.${CompanyTableColumns.id}
      WHERE 
        jar.${JobApplicationReferentsColumns.jobApplicationId} = $applicationId
        AND r.${ReferentTableColumns.id} = $referentId;
  ''';

      final result = await _db.rawQueryReadSingleItem(sql: sql);

      if (result == null) throw ItemNotFound();

      return ReferentDetails.fromJson(result);
    } catch (e, stackTrace) {
      throw ItemNotFound(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteReferent(int id) async {
    try {
      final result = await _db.delete(
        table: referentTableName,
        where: "${ReferentTableColumns.id} = ?",
        whereArgs: [id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }
}


