import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/states/change_screen_state.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';

enum Screen { list, form }

class ChangeScreenNotifier
    extends AutoDisposeNotifier<ScreenState<InterviewFollowUp>> {
  @override
  ScreenState<InterviewFollowUp> build() =>
      ScreenState(screen: Screen.list);

  void goToForm(InterviewFollowUp? followUp) {
    state = ScreenState(screen: Screen.form, data: followUp);
  }

  void goToList() {
    state = ScreenState(screen: Screen.list);
  }
}

final changeScreenProvider = AutoDisposeNotifierProvider<
  ChangeScreenNotifier,
  ScreenState<InterviewFollowUp>
>(ChangeScreenNotifier.new);

