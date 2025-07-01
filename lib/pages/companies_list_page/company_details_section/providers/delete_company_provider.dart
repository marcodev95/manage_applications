import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/providers/companies_paginator_notifier.dart';
import 'package:manage_applications/repository/company_repository.dart';
import 'package:riverpod/riverpod.dart';

final deleteCompanyController = FutureProvider.autoDispose
    .family<OperationResult, int?>((ref, int? id) async {
      try {
        if (id == null) {
          throw MissingInformationError(error: 'ID_Azienda non presente');
        }

        final repository = ref.read(companyRepositoryProvider);

        await repository.deleteCompany(id);

        await ref.read(asyncCompaniesProvider.notifier).handleDeleteCompany(id);

        return Success(data: true);
      } catch (e, stackTrace) {
        return mapToFailure(e, stackTrace);
      }
    });
