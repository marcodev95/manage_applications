import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final interviewRepository = Provider(
  (_) => InterviewRepository(DbHelper.instance),
);

class InterviewRepository {
  InterviewRepository(final DbHelper dbHelper) : _db = dbHelper;

  final DbHelper _db;

  Future<Interview> getInterview(int id) async {
    try {
      final result = await _db.readSingleItem(
        table: interviewTable,
        where: "${InterviewTableColumns.id} = ?",
        whereArgs: [id],
      );

      return Interview.fromJson(result);
    } catch (e, stackTrace) {
      throw ItemNotFound(error: e, stackTrace: stackTrace);
    }
  }

  Future<Interview> addInterview(Interview interview) async {
    try {
      final result = await _db.create(
        table: interviewTable,
        json: interview.toJson(),
      );

      return interview.copyWith(id: result);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateInterview(Interview interview) async {
    try {
      final result = await _db.update(
        table: interviewTable,
        json: interview.toJson(),
        where: "${InterviewTableColumns.id} = ?",
        whereArgs: [interview.id],
      );

      if (result == 0) throw ItemNotFound(stackTrace: StackTrace.current);
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteInterview(int id) async {
    try {
      final result = await _db.delete(
        table: interviewTable,
        where: "${InterviewTableColumns.id} = ?",
        whereArgs: [id],
      );

      if (result == 0) throw ItemNotFound(stackTrace: StackTrace.current);
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }
}
