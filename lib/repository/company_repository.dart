import 'dart:async';

import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final companyRepositoryProvider = Provider(
  (_) => CompanyRepository(DbHelper.instance),
);

class CompanyRepository {
  final DbHelper _db;
  final _table = companyTable;

  CompanyRepository(DbHelper db) : _db = db;

  Future<List<Company>> getAllCompaniesRows({List<String>? columns}) async {
    try {
      final result = await _db.readAllItems(table: _table, columns: columns);

      return List<Company>.from(result.map((e) => Company.fromJson(e)));
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<Company> getCompanyDetails(int id) async {
    try {
      final result = await _db.readSingleItem(
        table: _table,
        where: "${CompanyTableColumns.id} = ?",
        whereArgs: [id],
      );

      if (result.isEmpty) throw ItemNotFound();

      return Company.fromJson(result);
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateCompany(Company company) async {
    try {
      final result = await _db.update(
        table: _table,
        where: "${CompanyTableColumns.id} = ?",
        whereArgs: [company.id],
        json: company.toJson(),
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<Company> addCompany(Company company) async {
    try {
      final lastId = await _db.create(table: _table, json: company.toJson());

      return company.copyWith(id: lastId);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteCompany(int companyId) async {
    try {
      final result = await _db.delete(
      table: _table,
      where: "${CompanyTableColumns.id} = ?",
      whereArgs: [companyId],
    );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }

  Future<List<Company>> fetchCompaniesPage ({
    required int itemsPerPage,
    required int offset,
  }) async {
    final sql = '''

      SELECT 
        ${CompanyTableColumns.id},
        ${CompanyTableColumns.name},
        ${CompanyTableColumns.city},
        ${CompanyTableColumns.email},
        ${CompanyTableColumns.website}

      FROM $companyTable
      
      ORDER BY ${CompanyTableColumns.id}

      LIMIT $itemsPerPage OFFSET $offset
    
    ''';

    try {
      final result = await _db.rawQuery(sql: sql);

      return List<Company>.from(result.map((e) => Company.fromJson(e)));
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }
}
