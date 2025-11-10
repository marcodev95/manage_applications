import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/states/change_screen_state.dart';

enum CompanyScreen { initial, mainCompanyForm, clientCompanyForm, referentForm }

class CompanyChangeScreenNotifer<T>
    extends AutoDisposeNotifier<ScreenState<int?>> {
  @override
  ScreenState<int?> build() {
    return ScreenState(screen: CompanyScreen.initial);
  }

  void goBack() => state = ScreenState(screen: CompanyScreen.initial);

  void goToCompanyForm(CompanyScreen screen) {
    state = ScreenState(screen: screen);
  }

  void goToReferentCompanyForm([int? id]) {
    state = ScreenState(data: id, screen: CompanyScreen.referentForm);
  }
}

final companyChangeScreenProvider =
    AutoDisposeNotifierProvider<CompanyChangeScreenNotifer, ScreenState<int?>>(
      CompanyChangeScreenNotifer.new,
    );