import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/client_company/client_company_form_notifier.dart';
import 'package:riverpod/riverpod.dart';

final referentCompanyOptionsProvider = Provider.autoDispose<List<CompanyOption>>((
  ref,
) {
  final applied = ref.watch(appliedCompanyFormProvider).value;
  final client = ref.watch(clientCompanyFormProvider).value;

  if (applied == null && client == null) {
    return [];
  }

  if (client == null || client.id == null) {
    return [applied!.asMain];
  }

  return [applied!.asMain, client.asClient];
});
