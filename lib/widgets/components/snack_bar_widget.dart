import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:flutter/material.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_notifier.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarMessage({
  required Icon icon,
  required String message,
  required BuildContext context,

  SnackBarAction? snackBarAction,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black12,
      content: Row(
        spacing: 20.0,
        children: [
          icon,
          //Icon(Icons.error_outline, color: Colors.red),
          Text(message, style: TextStyle(color: Colors.white, fontSize: 16.0)),
        ],
      ),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 3),
      width: 650.0,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackBar({
  required String message,
  required BuildContext context,
}) {
  return showSnackBarMessage(
    icon: Icon(Icons.check, color: Colors.green),
    message: message,
    context: context,
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar({
  required String message,
  required BuildContext context,
}) {
  return showSnackBarMessage(
    icon: Icon(Icons.error_outline, color: Colors.red),
    message: message,
    context: context,
  );
}

void printErrorUtility(Failure? failure) {
  debugPrint("Error => ${failure?.error}");
  debugPrint("Stack => ${failure?.stackTrace}");
}

extension ListenAsyncValueWithSnackBar on WidgetRef {
  void listenOnErrorWithSnackbar<T>({
    required ProviderListenable<AsyncValue<T>> provider,
    required BuildContext context,
    void Function(Object, StackTrace)? onError,
  }) {
    listen<AsyncValue<T>>(provider, (_, state) {
      state.whenOrNull(
        error: (error, stackTrace) {
          final failure = mapToFailure(error, stackTrace);
          read(errorsProvider.notifier).addFailure(failure);
          showErrorSnackBar(message: failure.message, context: context);
          /*  if (error is Failure) {
            read(errorsProvider.notifier).addFailure(error);
            showErrorSnackBar(message: error.message, context: context);
          } else {
            final failure = mapToFailure(error, stackTrace);
            read(errorsProvider.notifier).addFailure(failure);
            showErrorSnackBar(message: failure.message, context: context);
          } */
        },
      );
    });
  }

  void listenOnErrorWithoutSnackbar<T>({
    required ProviderListenable<AsyncValue<T>> provider,
    required BuildContext context,
    void Function(Object, StackTrace)? onError,
  }) {
    listen<AsyncValue<T>>(provider, (_, state) {
      /*  Riverpod notifica due AsyncError diversi: uno con isLoading: true e uno normale. 
          Anche se l'errore è lo stesso, Riverpod considera questi due stati diversi. 
          Quindi si filtra in base al flag isLoading.
      */
      if (state.hasError && !state.isLoading) {
        state.whenOrNull(
          error: (error, stackTrace) {
            if (error is Failure) {
              read(errorsProvider.notifier).addFailure(error);
            } else {
              final failure = Failure(
                error: error,
                stackTrace: stackTrace,
                message: ErrorsMessage.unknownError,
              );
              read(errorsProvider.notifier).addFailure(failure);
            }
          },
        );
      }
    });
  }
}

/* void listenAsyncValueWithSnackBar<T>({
    required ProviderListenable<AsyncValue<T>> provider,
    required BuildContext context,
    required String successMessage,
    void Function(T data)? onData,
    void Function(Object, StackTrace)? onError,
  }) {
    listen<AsyncValue<T>>(provider, (_, state) {
      state.whenOrNull(
        data: (data) {
          showSuccessSnackBar(message: successMessage, context: context);
          if (onData != null) onData(data);
        },
        error: (error, stackTrace) {
          if (error is Failure) {
            read(errorsProvider.notifier).addFailure(error);
            showErrorSnackBar(message: error.message, context: context);
          } else {
            read(
              errorsProvider.notifier,
            ).addFailure(UnknownError(error: error, stackTrace: stackTrace));
            showErrorSnackBar(
              message: ErrorsMessage.unknownError,
              context: context,
            );
          }
        },
      );
    });
  } */
