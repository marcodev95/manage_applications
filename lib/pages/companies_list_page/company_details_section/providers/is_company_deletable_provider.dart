import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/client_company_applications_section/client_company_applications_provider.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/main_company_applications_section/main_company_applications_provider.dart';

final isCompanyDeletableProvider = Provider.autoDispose.family<bool, int>((
  ref,
  companyId,
) {
  final applicationsMainCompany = ref
      .watch(mainCompanyApplicationsProvider(companyId))
      .maybeWhen(data: (data) => data.isEmpty, orElse: () => false);

  final applicationsClientCompany = ref
      .watch(clientCompanyApplicationsProvider(companyId))
      .maybeWhen(data: (data) => data.isEmpty, orElse: () => false);

  return applicationsClientCompany && applicationsMainCompany;
});
