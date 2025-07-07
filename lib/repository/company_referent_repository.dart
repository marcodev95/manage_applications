import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final companyReferentRepositoryProvider = Provider(
  (_) => CompanyReferentRepository(DbHelper.instance),
);

class CompanyReferentRepository {
  final DbHelper _db;

  CompanyReferentRepository(DbHelper db) : _db = db;

  Future<CompanyReferentDetails> addCompanyReferent(
    CompanyReferentDetails referent,
  ) async {
    try {

      final lastId = await _db.create(
        table: companyReferentTableName,
        json: CompanyReferentDetails.toDB(referent).toJson(),
      );

      return referent.copyWith(id: lastId);
    } catch (e, stackTrace) {
      if (e is MissingInformationError) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateCompanyReferent(CompanyReferent referent) async {
    try {
      final result = await _db.update(
        table: companyReferentTableName,
        json: referent.toJson(),
        where: "${CompanyReferentTableColumns.id} = ?",
        whereArgs: [referent.id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<CompanyReferentDetails> getCompanyReferentDetails(int id) async {
    try {
      final sql = '''
    SELECT 
      cr.${CompanyReferentTableColumns.id},
      cr.${CompanyReferentTableColumns.name},
      cr.${CompanyReferentTableColumns.role},
      cr.${CompanyReferentTableColumns.email},
      cr.${CompanyReferentTableColumns.companyType},
      cr.${CompanyReferentTableColumns.phoneNumber},
      cr.${CompanyReferentTableColumns.companyId},

      c.${CompanyTableColumns.id} AS company_id,
      c.${CompanyTableColumns.name} AS company_name

    FROM $companyReferentTableName AS cr
    INNER JOIN $companyTable AS c 
      ON cr.${CompanyReferentTableColumns.companyId} = c.${CompanyTableColumns.id}
    
    WHERE cr.${CompanyReferentTableColumns.id} = $id
  ''';

      final result = await _db.rawQueryReadSingleItem(sql: sql);

      if (result == null) throw ItemNotFound();

      return CompanyReferentDetails.fromJson(result);
    } catch (e, stackTrace) {
      throw ItemNotFound(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteCompanyReferent(int id) async {
    try {
      final result = await _db.delete(
        table: companyReferentTableName,
        where: "${CompanyReferentTableColumns.id} = ?",
        whereArgs: [id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }
}
