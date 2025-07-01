import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/applications_related_client_company_section/applications_related_client_company_notifier.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/applications_related_main_company_section/applications_related_main_company_notifier.dart';

final isCompanyDeletableProvider = Provider.autoDispose
    .family<bool, int>((ref, companyId) {
      final applicationsMainCompany = ref
          .watch(applicationsRelatedMainCompanyProvider(companyId))
          .maybeWhen(data: (data) => data.isEmpty, orElse: () => false);

      final applicationsClientCompany = ref
          .watch(applicationsRelatedClientCompanyProvider(companyId))
          .maybeWhen(data: (data) => data.isEmpty, orElse: () => false);

      return applicationsClientCompany && applicationsMainCompany;
    });
