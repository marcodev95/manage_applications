import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_notifier.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';

sealed class OperationResult<T> {
  const OperationResult();
}

class Success<T> extends OperationResult<T> {
  final T data;
  final String message;

  const Success({
    required this.data,
    this.message = SuccessMessage.genericMessage,
  });

  @override
  String toString() {
    return ''' { Data: $data } ''';
  }
}

class Failure<T> extends OperationResult with EquatableMixin implements Exception {
  final String id;
  final Object? error;
  final StackTrace stackTrace;
  final String message;
  final DateTime errorDate;

  Failure({
    required this.error,
    this.message = ErrorsMessage.genericMessage,
    StackTrace? stackTrace,
  }) : id =
           "${DateTime.now().microsecondsSinceEpoch}_${error.runtimeType}_${error.hashCode}",
       errorDate = DateTime.now(),
       stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() {
    return "Error => ${error.toString()} || Stack => ${stackTrace.toString()}";
  }

  @override
  List<Object?> get props => [id];
}

Failure mapToFailure(Object error, StackTrace stackTrace) {
  if (error is Failure) return error;

  if (error is StateError) {
    return Failure(
      error: error,
      message: error.message,
      stackTrace: error.stackTrace,
    );
  }

  return Failure(
    error: error,
    stackTrace: stackTrace,
    message: ErrorsMessage.unknownError,
  );
}

extension OperationResultX<T> on OperationResult<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure;

  T? get dataOrNull => switch (this) {
    Success<T> s => s.data,
    _ => null,
  };

  T get data => switch (this) {
    Success<T> s => s.data,
    _ => throw MissingInformationError(stackTrace: StackTrace.current),
  };

  Failure get failure => switch (this) {
    Failure f => f,
    _ => UnknownError(),
  };

  String get message => switch (this) {
    Success(:final message) => message,
    Failure(:final message) => message,
  };

  void handleResult({required BuildContext context, required WidgetRef ref}) {
    if (isSuccess) {
      showSuccessSnackBar(message: message, context: context);
    } else {
      ref.read(errorsProvider.notifier).addFailure(failure);
      showErrorSnackBar(message: message, context: context);
    }
  }

  void handleErrorResult({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    if (isFailure) {
      ref.read(errorsProvider.notifier).addFailure(failure);
      showErrorSnackBar(message: message, context: context);
    }
  }

  void logIfFailure() {
    if (this case Failure(:final error)) {
      debugPrint('Errore: $error');
    }
  }
}

class SaveError extends Failure {
  SaveError({
    super.message = ErrorsMessage.saveMessage,
    required super.error,
    super.stackTrace,
  });
}

class DataLoadingError extends Failure {
  DataLoadingError({
    super.error,
    super.message = ErrorsMessage.dataLoading,
    super.stackTrace,
  });
}

class DeleteError extends Failure {
  DeleteError({
    super.message = ErrorsMessage.deleteMessage,
    required super.error,
    super.stackTrace,
  });
}

class ItemNotFound extends Failure {
  ItemNotFound({
    super.message = ErrorsMessage.itemNotFound,
    super.error,
    super.stackTrace,
  });
}

class MissingInformationError extends Failure {
  MissingInformationError({
    super.error,
    super.message = ErrorsMessage.keyInformationsAreMissing,
    super.stackTrace,
  });
}

class UnknownError extends Failure {
  UnknownError({
    super.error,
    super.message = ErrorsMessage.unknownError,
    super.stackTrace,
  });
}
