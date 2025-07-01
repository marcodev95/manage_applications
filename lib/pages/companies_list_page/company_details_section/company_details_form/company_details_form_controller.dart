import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/providers/get_company_details_provider.dart';

class CompanyDetailsFormController extends AutoDisposeFamilyAsyncNotifier<Company, int?> {
  @override
  FutureOr<Company> build(int? arg) async {
      final details = await ref.watch(getCompanyDetailsProvider(arg).future);

      return details;
  }

  

}