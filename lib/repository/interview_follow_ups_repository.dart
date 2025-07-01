import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final interviewFollowUpsRepositoryProvider = Provider(
  (_) => InterviewFollowUpsRepository(DbHelper.instance),
);

class InterviewFollowUpsRepository {
  final DbHelper _db;

  InterviewFollowUpsRepository(final DbHelper db) : _db = db;

  Future<InterviewFollowUp> addFollowUp(InterviewFollowUp followUp) async {
    try {
      final result = await _db.create(
        table: interviewFollowUpTable,
        json: followUp.toJson(),
      );
      return followUp.copyWith(id: result);
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateFollowUp(InterviewFollowUp followUp) async {
    try {
      final result = await _db.update(
        table: interviewFollowUpTable,
        where: "${InterviewFollowUpColumns.id} = ?",
        whereArgs: [followUp.id],
        json: followUp.toJson(),
      );

      if (result == 0) {
        throw ItemNotFound(stackTrace: StackTrace.current);
      }
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<void> deleteFollowUp(int id) async {
    try {
      final result = await _db.delete(
        table: interviewFollowUpTable,
        where: "${InterviewFollowUpColumns.id} = ?",
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
