import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';

class ErrorsNotifier extends Notifier<List<Failure>> {
  @override
  List<Failure> build() {
    return [];
  }

  void addFailure(Failure failure) {
    state = [...state, failure];
  }

  void deleteFailure(Failure failure) {
    state = state.where((f) => f.id != failure.id).toList();
  }
}

final errorsProvider = NotifierProvider<ErrorsNotifier, List<Failure>>(
  ErrorsNotifier.new,
);

final countErrorsProvider = Provider<int>(
  (ref) => ref.watch(errorsProvider).length,
);
