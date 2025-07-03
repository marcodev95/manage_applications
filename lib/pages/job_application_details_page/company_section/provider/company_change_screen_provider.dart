import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/states/change_screen_state.dart';

enum CompanyScreen { initial, mainCompanyForm, clientCompanyForm, referentForm }

class CompanyChangeScreenNotifer<T>
    extends AutoDisposeNotifier<ScreenState<CompanyScreenData>> {
  @override
  ScreenState<CompanyScreenData> build() {
    return ScreenState(screen: CompanyScreen.initial);
  }

  void goBack() => state = ScreenState(screen: CompanyScreen.initial);

  void goToMainCompanyForm([Company? company]) {
    state = ScreenState(
      data: CompanyScreenData(mainCompany: company),
      screen: CompanyScreen.mainCompanyForm,
    );
  }

  void goToClientCompanyForm([Company? company]) {
    state = ScreenState(
      data: CompanyScreenData(clientCompany: company),
      screen: CompanyScreen.clientCompanyForm,
    );
  }

  void goToReferentCompanyForm([int? id]) {
    state = ScreenState(
      data: CompanyScreenData(referentId: id),
      screen: CompanyScreen.referentForm,
    );
  }
}

final companyChangeScreenProvider = AutoDisposeNotifierProvider<
  CompanyChangeScreenNotifer,
  ScreenState<CompanyScreenData>
>(CompanyChangeScreenNotifer.new);

class CompanyScreenData {
  final Company? mainCompany;
  final Company? clientCompany;
  final int? referentId;

  CompanyScreenData({this.mainCompany, this.clientCompany, this.referentId});
}
