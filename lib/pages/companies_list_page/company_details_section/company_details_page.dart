import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/company_details_barrel.dart';
import 'package:manage_applications/providers/companies_paginator_notifier.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_panel_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class CompanyDetailsPage extends ConsumerStatefulWidget {
  const CompanyDetailsPage(this.companyId, {super.key});

  final int companyId;

  @override
  ConsumerState<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends ConsumerState<CompanyDetailsPage> {
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    ref.listenOnErrorWithoutSnackbar(
      provider: getCompanyDetailsProvider(widget.companyId),
      context: context,
    );

    final companyDetailsAsync = ref.watch(
      getCompanyDetailsProvider(widget.companyId),
    );

    return DefaultTabController(
      length: _tabs.length,
      child: companyDetailsAsync.when(
        data:
            (details) => Scaffold(
              appBar: AppBar(
                title: Text('Dettagli azienda: ${details.name}'),
                actions: [
                  _DeleteCompanyButton(widget.companyId),
                  const SizedBox(width: 20.0),
                  const ErrorsPanelButtonWidget(),
                ],
                bottom: TabBar(
                  onTap: (int index) {
                    _currentPage.value = index;
                  },
                  tabs: _tabs,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(AppStyle.pad24),
                child: _PageTabsWidget(details, _currentPage),
              ),
            ),
        error: (_, __) {
          return DataLoadErrorScreenWidget(
            onPressed:
                () =>
                    ref.invalidate(getCompanyDetailsProvider(widget.companyId)),
            onGoBack: () => Navigator.pop(context),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

List<Tab> get _tabs => [
  Tab(text: 'Dettagli azienda'),
  Tab(text: 'Lista candidature come azienda principale'),
  Tab(text: 'Lista candidature come azienda cliente'),
];

class _PageTabsWidget extends ConsumerWidget {
  const _PageTabsWidget(this.details, this.notifier);

  final Company details;
  final ValueNotifier<int> notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (_, value, __) {
        return IndexedStack(
          index: value,
          children: [
            AppCard(child: CompanyDetailsForm(details)),
            MainCompanyApplicationsSection(details.id!),
            ClientCompanyApplicationsSection(details.id!),
          ],
        );
      },
    );
  }
}

class _DeleteCompanyButton extends ConsumerWidget {
  const _DeleteCompanyButton(this.companyId);

  final int companyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(isCompanyDeletableProvider(companyId));

    return isVisible
        ? RemoveButtonWidget(
          onPressed: () async {
            final notifier = ref.read(companiesPaginatorProvider.notifier);
            final result = await notifier.deleteCompany(companyId);

            if (!context.mounted) return;

            result.handleErrorResult(context: context, ref: ref);

            if (result.isSuccess) Navigator.pop(context);
          },
        )
        : const SizedBox();
  }
}
