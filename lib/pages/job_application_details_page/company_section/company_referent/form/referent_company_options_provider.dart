import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/applied_company_section/applied_company_form_controller.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/client_company_section/client_company_form_controller.dart';
import 'package:riverpod/riverpod.dart';

final referentCompanyOptionsProvider = Provider.autoDispose<List<CompanyOption>>((
  ref,
) {
  final applied = ref.watch(appliedCompanyFormController).value;
  final client = ref.watch(clientCompanyFormController).value;

  if (applied == null && client == null) {
    return [];
  }

  if (client == null || client.id == null) {
    return [applied!.asMain];
  }

  return [applied!.asMain, client.asClient];
});
