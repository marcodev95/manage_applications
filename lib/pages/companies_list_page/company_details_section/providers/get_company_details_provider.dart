import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/repository/company_repository.dart';

final getCompanyDetailsProvider = FutureProvider.autoDispose
    .family<Company, int?>((ref, int? id) async {

      if(id == null) throw MissingInformationError(error: 'ID_Azienda mancante');

      final repository = ref.read(companyRepositoryProvider);

      return await repository.getCompanyDetails(id);
    });
