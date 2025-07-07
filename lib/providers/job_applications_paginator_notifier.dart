import 'dart:async';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/job_application/job_application_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/states/paginator_state.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_utility.dart';
import 'package:manage_applications/providers/job_application_filter.dart';
import 'package:manage_applications/repository/job_data_repository.dart';

class JobApplicationsPaginatorNotifier
    extends AsyncNotifier<PaginatorState<JobApplicationUi>> {
  Future<PaginatorState<JobApplicationUi>> fetchData(
    int pageNumber, [
    String? statusFilter,
  ]) async {
    final repository = ref.read(jobApplicationRepositoryProvider);

    final applicationsUI = await repository.fetchJobApplicationsPage(
      itemsPerPage: PaginatorState.itemsPerPage + 1,
      offset: pageNumber * PaginatorState.itemsPerPage,
      statusFilter: statusFilter,
    );

    final visibleApplicationsUI =
        applicationsUI.take(PaginatorState.itemsPerPage).toList();

    return PaginatorState<JobApplicationUi>(
      items: visibleApplicationsUI,
      hasNextPage: applicationsUI.length > PaginatorState.itemsPerPage,
    );
  }

  @override
  FutureOr<PaginatorState<JobApplicationUi>> build() async {
    final filter = ref.watch(applicationFilterProvider);

    return await _fetchFilteredData(0, filter);
  }

  Future<PaginatorState<JobApplicationUi>> _fetchFilteredData(
    int pageNumber,
    ApplicationFilter filter,
  ) async {
    switch (filter) {
      case ApplicationFilter.all:
        return await fetchData(pageNumber);
      case ApplicationFilter.bookmark:
        return await fetchData(pageNumber, 'Salvato');
      case ApplicationFilter.apply:
        return await fetchData(pageNumber, ApplicationStatus.apply.name);
      case ApplicationFilter.interview:
        return await fetchData(pageNumber, ApplicationStatus.interview.name);
      case ApplicationFilter.pendingResponse:
        return await fetchData(
          pageNumber,
          ApplicationStatus.pendingResponse.name,
        );
    }
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

    await _loadPage(currentState.pageNumber - 1);
  }

  Future<void> reloadCurrentPage() async {
    final currentState = _currentStateOrFail(
      'Non è stato possibile ricaricare la pagina.',
    );

    if (currentState == null) return;

    await _loadPage(currentState.pageNumber);
  }

  Future<void> handleAddJobApplication() async {
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

  void updateCompanyRef({required int id, required CompanyRef companyRef}) {
    state = state.whenData((value) {
      final index = value.items.indexWhere((el) => el.id == id);
      if (index == -1) {
        return value;
      }

      final updatedList = List.of(value.items);
      updatedList[index] = updatedList[index].copyWith(companyRef: companyRef);
      return value.copyWith(items: updatedList);
    });
  }

  void updateCompanyNameForCompany(CompanyRef companyRef) {
    state = state.whenData((value) {
      final updatedList =
          value.items.map((app) {
            if (app.companyRef?.id == companyRef.id) {
              return app.copyWith(companyRef: companyRef);
            }
            return app;
          }).toList();

      return value.copyWith(items: updatedList);
    });
  }

  Future<OperationResult> deleteJobApplication(int id) async {
    final repository = ref.read(jobApplicationRepositoryProvider);
    final currentState = _currentStateOrFail(
      'Non è stato possibile caricare i dati.',
    );

    if (currentState == null) {
      return mapToFailure(state.error!, state.stackTrace!);
    }

    state = const AsyncLoading();

    try {
      await repository.deleteJobApplication(id);

      final filteredList = currentState.items.where((a) => a.id != id).toList();

      if (filteredList.isEmpty) {
        await goBack();
      } else {
        await reloadCurrentPage();
      }

      return Success<bool>(data: true, message: SuccessMessage.deleteMessage);
    } catch (e, stackTrace) {
      return mapToFailure(e, stackTrace);
    }
  }

  Future<void> _loadPage(int pageNumber) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final filter = ref.read(applicationFilterProvider);
      final paginator = await _fetchFilteredData(pageNumber, filter);
      return paginator.copyWith(pageNumber: pageNumber);
    });
  }

  void _failState(Object error, [StackTrace? stackTrace]) {
    state = AsyncError(error, stackTrace ?? StackTrace.current);
  }

  PaginatorState<JobApplicationUi>? _currentStateOrFail(String errorMessage) {
    final current = state.value;
    if (current == null) {
      _failState(StateError(errorMessage));
      return null;
    }
    return current;
  }
}

final paginatorApplicationsUIProvider = AsyncNotifierProvider<
  JobApplicationsPaginatorNotifier,
  PaginatorState<JobApplicationUi>
>(() => JobApplicationsPaginatorNotifier());

final applicationFilterProvider = StateProvider((_) => ApplicationFilter.all);
