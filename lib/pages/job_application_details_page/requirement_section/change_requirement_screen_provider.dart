import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/states/change_screen_state.dart';
import 'package:manage_applications/models/requirement.dart';

enum Screen { list, form }

class ChangeRequirementScreenNotifier
    extends AutoDisposeNotifier<ScreenState<Requirement>> {
  @override
  ScreenState<Requirement> build() =>
      ScreenState(screen: Screen.list);

  void goToForm([Requirement? requirement]) {
    state = state.copyWith(screen: Screen.form, data: requirement);
  }

  void goToList() {
    state = ScreenState(screen: Screen.list);
  }
}

final changeRequirementScreenProvider = AutoDisposeNotifierProvider<
  ChangeRequirementScreenNotifier,
  ScreenState<Requirement>
>(ChangeRequirementScreenNotifier.new);
