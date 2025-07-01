/* import 'dart:async';

import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/api_result.dart';

class Repository<T> {
  final String table;

  Repository({required this.table});

  Future<ApiResult<List<T>?>> getAllRows({
    required T Function(Map<String, dynamic>) rowMapper,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final result = await DbHelper.instance.readAllItems(
        table: table,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
      );

      final list = List<T>.from(result.map((e) => rowMapper(e)));

      return ApiResult(
        success: true,
        data: list,
      );
    } catch (error, stackTrace) {
      return ApiResult(
        success: false,
        failure: Failure(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<ApiResult<T?>> getSingleRow({
    required T Function(Map<String, dynamic>) rowMapper,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final result = await DbHelper.instance.readSingleItem(
        table: table,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
      );

      final item = rowMapper(result);

      return ApiResult<T>(
        success: true,
        data: item,
      );
    } catch (error, stackTrace) {
      return ApiResult(
        success: false,
        failure: Failure(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<ApiResult<int?>> addRow({required Map<String, Object?> json}) async {
    try {
      final int lastId = await DbHelper.instance.create(
        table: table,
        json: json,
      );
      return ApiResult<int>(
        success: true,
        data: lastId,
      );
    } catch (error, stackTrace) {
      return ApiResult(
        success: false,
        failure: Failure(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<ApiResult<int?>> deleteRow({
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final int result = await DbHelper.instance.delete(
        table: table,
        where: where,
        whereArgs: whereArgs,
      );
      return ApiResult<int>(
        success: true,
        data: result,
      );
    } catch (error, stackTrace) {
      return ApiResult(
        success: false,
        failure: Failure(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<ApiResult<int?>> updateRow({
    required Map<String, Object?> json,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final int result = await DbHelper.instance.update(
        table: table,
        json: json,
        where: where,
        whereArgs: whereArgs,
      );
      return ApiResult<int>(
        success: true,
        data: result,
      );
    } catch (error, stackTrace) {
      return ApiResult(
        success: false,
        failure: Failure(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}

class RawRepository {
  final String sql;

  RawRepository({required this.sql});

  Future<ApiResult<List<Map<String, Object?>>>> getAllRows() async {
    try {
      final result = await DbHelper.instance.rawQuery(sql: sql);
      return ApiResult(
        success: true,
        data: result,
      );
    } catch (error, stackTrace) {
      return ApiResult(
        success: false,
        failure: Failure(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<ApiResult<Map<String, Object?>>> getSingleRow() async {
    try {
      final result = await DbHelper.instance.rawQuery(sql: sql);
      return ApiResult(success: true, data: result.first);
    } catch (error, stackTrace) {
      return ApiResult(
          success: false,
          failure: Failure(error: error, stackTrace: stackTrace));
    }
  }

  Future<ApiResult<int?>> rawUpdate(List<Object?>? arguments) async {
    try {
      final result =
          await DbHelper.instance.rawUpdate(sql: sql, arguments: arguments);
      return ApiResult(
        success: true,
        data: result,
      );
    } catch (error, stackTrace) {
      return ApiResult(
          success: false,
          failure: Failure(
            error: error,
            stackTrace: stackTrace,
          ));
    }
  }
}
 */