import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final contractRepositoryProvider = Provider(
  (_) => ContractRepository(DbHelper.instance),
);

class ContractRepository {
  final DbHelper _instance;

  ContractRepository(final DbHelper instance) : _instance = instance;

  Future<Contract> getContract(int contractId) async {
    try {
      final result = await _instance.readSingleItem(
        table: contractTable,
        where: "${ContractTableColumns.id} = ?",
        whereArgs: [contractId],
      );

      if (result.isEmpty) throw ItemNotFound();

      return Contract.fromJson(result);
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<int> createContract(Map<String, dynamic> json) async {
    return await _instance.create(table: contractTable, json: json);
  }

  Future<int> updateContract(Map<String, dynamic> json, int id) async {
    return await _instance.update(
      table: contractTable,
      json: json,
      where: "${ContractTableColumns.id} = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateRemuneration(Map<String, dynamic> json, int id) async {
    return await _instance.update(
      table: contractTable,
      json: json,
      where: "${ContractTableColumns.id} = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteContract(int idContract) async {
    return await _instance.delete(
      table: contractTable,
      where: "${ContractTableColumns.id} = ?",
      whereArgs: [idContract],
    );
  }
}
