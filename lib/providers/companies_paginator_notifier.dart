import 'dart:async';

import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/states/paginator_state.dart';
import 'package:manage_applications/repository/company_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompaniesPaginatorNotifier
    extends AutoDisposeAsyncNotifier<PaginatorState<Company>> {
  Future<PaginatorState<Company>> _getAllCompaniesRows(int pageNumber) async {
    final repository = ref.read(companyRepositoryProvider);

    final companies = await repository.paginatorQuery(
      itemsPerPage: PaginatorState.itemsPerPage + 1,
      offset: pageNumber * PaginatorState.itemsPerPage,
    );

    final visibleCompanies =
        companies.take(PaginatorState.itemsPerPage).toList();

    return PaginatorState(
      items: visibleCompanies,
      hasNextPage: companies.length > PaginatorState.itemsPerPage,
    );
  }

  @override
  FutureOr<PaginatorState<Company>> build() async {
    return await _getAllCompaniesRows(0);
  }

  Future<void> nextPage() async {
    final currentState = _currentStateOrFail(
      'Non è stato possibile caricare la pagina successiva.',
    );

    if (currentState == null) return;
    
    await _loadPage(currentState.pageNumber + 1);
  }

  Future<void> goBack() async {
    final currentState = _currentStateOrFail(
      'Non è stato possibile caricare la pagina precedente.',
    );

    if (currentState == null) return;

    if (currentState.pageNumber == 0) return;

    await _loadPage(currentState.pageNumber - 1);
  }

  Future<void> reloadCurrentPage() async {
    final currentState = _currentStateOrFail(
      'Non è stato possibile ricaricare la pagina.',
    );

    if (currentState == null) return;

    await _loadPage(currentState.pageNumber);
  }

  Future<OperationResult> deleteCompany(int? companyId) async {
    try {
      if (companyId == null) {
        throw MissingInformationError(error: 'ID_Azienda non presente');
      }

      final repository = ref.read(companyRepositoryProvider);

      await repository.deleteCompany(companyId);

      await _handleDeleteCompany(companyId);

      return Success(data: true);
    } catch (e, stackTrace) {
      _failState(e, stackTrace);
      return mapToFailure(e, stackTrace);
    }
  }

  Future<void> handleAddCompany() async {
    final currentState = _currentStateOrFail(
      'Non è stato possibile caricare i dati.',
    );

    if (currentState == null) return;

    if (currentState.itemsLength >= PaginatorState.itemsPerPage) {
      await nextPage();
    } else {
      await reloadCurrentPage();
    }
  }

  Future<void> _handleDeleteCompany(int companyId) async {
    final currentState = _currentStateOrFail(
      'Non è stato possibile caricare i dati.',
    );

    if (currentState == null) return;

    final filteredList =
        currentState.items.where((c) => c.id != companyId).toList();

    if (filteredList.isEmpty) {
      await goBack();
    } else {
      await reloadCurrentPage();
    }
  }

  void _failState(Object error, [StackTrace? stackTrace]) {
    state = AsyncError(error, stackTrace ?? StackTrace.current);
  }

  PaginatorState<Company>? _currentStateOrFail(String errorMessage) {
    final current = state.value;
    if (current == null) {
      _failState(StateError(errorMessage));
      return null;
    }
    return current;
  }

  Future<void> _loadPage(int pageNumber) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final paginator = await _getAllCompaniesRows(pageNumber);
      return paginator.copyWith(pageNumber: pageNumber);
    });
  }
}

final companiesPaginatorProvider = AsyncNotifierProvider.autoDispose<
  CompaniesPaginatorNotifier,
  PaginatorState<Company>
>(CompaniesPaginatorNotifier.new);
