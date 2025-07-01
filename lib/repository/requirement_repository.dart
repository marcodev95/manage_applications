import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/requirement.dart';

final requirementRepository = Provider(
  (_) => RequirementRepository(DbHelper.instance),
);

class RequirementRepository {
  RequirementRepository(DbHelper db) : _db = db;

  final DbHelper _db;

  Future<Requirement> addRequirement(Requirement requirement) async {
    try {
      final result = await _db.create(
        table: requirementTable,
        json: requirement.toJson(),
      );

      return requirement.copyWith(id: result);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateRequirement(Requirement requirement) async {
    try {
      final result = await _db.update(
        json: requirement.toJson(),
        table: requirementTable,
        where: "${RequirementTableColumns.id} = ?",
        whereArgs: [requirement.id],
      );
      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteRequirement(int id) async {
    try {
      final result = await _db.delete(
        table: requirementTable,
        where: "${RequirementTableColumns.id} = ?",
        whereArgs: [id],
      );
      if (result == 0) throw ItemNotFound();
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }
}
