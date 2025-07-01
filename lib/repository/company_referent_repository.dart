import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

class Repository<T> {
  final DbHelper db;
  final String table;

  Repository({required this.table}) : db = DbHelper.instance;

  Future<List<T>> getAllRows({
    String? where,
    String? orderBy,
    List<Object?>? whereArgs,
    List<String>? columns,
    required T Function(Map<String, Object?>) rowMapper,
  }) async {
    final result = await db.readAllItems(
      table: table,
      where: where,
      columns: columns,
      whereArgs: whereArgs,
    );

    return List<T>.from(result.map((e) => rowMapper(e)));
  }

  Future<T> getSingleRow({
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    required T Function(Map<String, Object?>) rowMapper,
  }) async {
    final result = await db.readSingleItem(
      table: table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );

    return rowMapper(result);
  }

  Future<int> addRow(Map<String, Object?> json) async {
    return db.create(table: table, json: json);
  }

  Future<int> updateRow({
    required Map<String, Object?> json,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return db.update(
      table: table,
      json: json,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> deleteRow({String? where, List<Object?>? whereArgs}) async {
    return db.delete(table: table, where: where, whereArgs: whereArgs);
  }
}

final companyReferentRepositoryProvider = Provider(
  (_) => CompanyReferentRepository(DbHelper.instance),
);

class CompanyReferentRepository {
  final DbHelper _db;

  CompanyReferentRepository(DbHelper db) : _db = db;

  Future<CompanyReferentDetails> addCompanyReferent(
    CompanyReferentDetails referent,
    int? applicationId,
  ) async {
    try {
      if (applicationId == null) {
        throw MissingInformationError(error: 'ID_Application non presente');
      }

      final lastId = await _db.create(
        table: companyReferentTableName,
        json: CompanyReferentDetails.toDB(referent, applicationId).toJson(),
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
