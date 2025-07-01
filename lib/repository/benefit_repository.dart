import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/contract/benefit.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final benefitRepositoryProvider = Provider(
  (_) => BenefitRepository(DbHelper.instance),
);

class BenefitRepository {
  final DbHelper _db;

  BenefitRepository(final DbHelper db) : _db = db;

  Future<List<Benefit>> getAllBenefits(int contractId) async {
    try {
      final sql = '''
        SELECT ${BenefitsTable.id}, ${BenefitsTable.benefit}, ${BenefitsTable.contractId}
        FROM ${BenefitsTable.tableName}
        WHERE ${BenefitsTable.contractId} = $contractId
      ''';

      final result = await _db.rawQuery(sql: sql);

      return List<Benefit>.from(result.map((e) => Benefit.fromJson(e)));
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }

  Future<Benefit> addBenefit(Benefit benefit) async {
    try {
      final result = await _db.create(
        table: BenefitsTable.tableName,
        json: benefit.toJson(),
      );
      return benefit.copyWith(id: result);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateBenefit(Benefit benefit) async {
    try {
      final result = await _db.update(
        table: BenefitsTable.tableName,
        where: "${BenefitsTable.id} = ?",
        whereArgs: [benefit.id],
        json: {BenefitsTable.benefit: benefit.benefit},
      );

      if (result == 0) {
        throw ItemNotFound(stackTrace: StackTrace.current);
      }
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteBenefit(int id) async {
    try {
      final result = await _db.delete(
        table: BenefitsTable.tableName,
        where: "${BenefitsTable.id} = ?",
        whereArgs: [id],
      );
      if (result == 0) {
        throw ItemNotFound(stackTrace: StackTrace.current);
      }
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }
}
