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

  Future<Contract> createContract(Contract contract) async {
    try {
      final lastId = await _instance.create(
        table: contractTable,
        json: contract.toJson(),
      );
      return contract.copyWith(id: lastId);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateContract(Contract contract) async {
    try {
      final result = await _instance.update(
        table: contractTable,
        json: contract.toJson(),
        where: "${ContractTableColumns.id} = ?",
        whereArgs: [contract.id],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteContract(int idContract) async {
    try {
      final result = await _instance.delete(
        table: contractTable,
        where: "${ContractTableColumns.id} = ?",
        whereArgs: [idContract],
      );

      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }
}
