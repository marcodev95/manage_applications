import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/repository/company_referent_repository.dart';

final getReferentDetailsProvider = FutureProvider.autoDispose
    .family<CompanyReferentDetails, int>((ref, int id) async {
      final repository = ref.read(companyReferentRepositoryProvider);

      return await repository.getCompanyReferentDetails(id);
    });
