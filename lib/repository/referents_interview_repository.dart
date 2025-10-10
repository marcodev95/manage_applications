import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/interview/referent_with_affiliation.dart';
import 'package:manage_applications/models/interview/selected_referent_for_interview.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

final referentsInterviewRepository = Provider(
  (_) => ReferentsInterviewRepository(DbHelper.instance),
);

class ReferentsInterviewRepository {
  final DbHelper _db;

  ReferentsInterviewRepository(final DbHelper db) : _db = db;

  Future<OperationResult<SelectedReferentsForInterview>> associate(
    int interviewId,
    ReferentWithAffiliation referent,
  ) async {
    try {
      final lastId = await _db.create(
        table: referentsInterviewTable,
        json: SelectedReferentsForInterview.toJson(
          interviewId,
          referent.referent.id!,
        ),
      );

      return Success<SelectedReferentsForInterview>(
        data: SelectedReferentsForInterview(
          id: lastId,
          referentWithAffiliation: referent,
        ),
      );
    } catch (e, stackTrace) {
      throw SaveError(error: e, stackTrace: stackTrace);
    }
  }

  Future<OperationResult<bool>> removeAssociate(int referentInterviewId) async {
    try {
      final result = await _db.delete(
        table: referentsInterviewTable,
        where: '${ReferentsInterviewTableColumns.id} = ?',
        whereArgs: [referentInterviewId],
      );

      //Necessario perchè delete non da errore se non trova corrispondenza
      if (result == 0) {
        throw ItemNotFound(stackTrace: StackTrace.current);
      }

      return Success(data: true);
    } catch (e, stackTrace) {
      if (e is ItemNotFound) rethrow;

      throw DeleteError(error: e, stackTrace: stackTrace);
    }
  }
}
