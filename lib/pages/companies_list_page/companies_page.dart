import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/company_details_page.dart';
import 'package:manage_applications/providers/companies_paginator_notifier.dart';
import 'package:manage_applications/widgets/components/divider_widget.dart';
import 'package:manage_applications/widgets/components/paginator_widget.dart';
import 'package:manage_applications/widgets/components/pop_up_menu_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class CompaniesPage extends ConsumerWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginator = ref.watch(companiesPaginatorProvider);

    ref.listenOnErrorWithoutSnackbar(
      provider: companiesPaginatorProvider,
      context: context,
    );

    return paginator.when(
      skipLoadingOnReload: true,
      skipError: true,
      data:
          (paginator) => Padding(
            padding: EdgeInsets.all(AppStyle.pad16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10.0,
              children: [
                Expanded(child: CompaniesGrid(paginator.items)),

                const DividerWidget(),

                PaginatorWidget(
                  paginatorState: paginator,
                  previousPage: () => _previousPage(ref),
                  nextPage: () => _nextPage(ref),
                ),
              ],
            ),
          ),

      error: (e, stackTrace) {
        return DataLoadErrorScreenWidget(
          onPressed: () => ref.invalidate(companiesPaginatorProvider),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void _previousPage(WidgetRef ref) =>
      ref.read(companiesPaginatorProvider.notifier).goBack();
  void _nextPage(WidgetRef ref) =>
      ref.read(companiesPaginatorProvider.notifier).nextPage();
}

class CompaniesGrid extends ConsumerWidget {
  const CompaniesGrid(this.companies, {super.key});

  final List<Company> companies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.7,
      ),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];

        return AppCard(
          externalPadding: const EdgeInsets.all(AppStyle.pad16),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _popupMenuButtonWidget(company, context, ref),
                ],
              ),
              Flexible(
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.location_on_sharp, color: Colors.deepOrange),
                    Text(
                      '${company.address}, ${company.city}',
                      style: const TextStyle(
                        fontSize: AppStyle.tableTextFontSize,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(child: EmailClipBoardWidget(company.email)),
            ],
          ),
        );
      },
    );
  }
}

PopupMenuButtonWidget _popupMenuButtonWidget(
  Company company,
  BuildContext context,
  WidgetRef ref,
) {
  return PopupMenuButtonWidget<String>(
    popupMenuEntry: [
      PopupMenuItem(
        value: "details",
        child: const Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.description_sharp, color: Colors.amber),
            Text('Dettagli dell\'azienda'),
          ],
        ),
        onTap: () => navigatorPush(context, CompanyDetailsPage(company.id!)),
      ),
      PopupMenuItem<String>(
        value: "url",
        child: const Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Icon(Icons.link, color: Colors.blue), Text('Sito web')],
        ),
        onTap:
            () async =>
                await tryToLaunchUrl(context: context, link: company.website),
      ),
    ],
  );
}

class EmailClipBoardWidget extends StatelessWidget {
  const EmailClipBoardWidget(this.email, {super.key});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Icon(Icons.email, color: Colors.blue),
        InkWell(
          onTap: () {
            if (email.isNotEmpty) {
              Clipboard.setData(ClipboardData(text: email));
              showSuccessSnackBar(
                message: 'Testo copiato negli appunti',
                context: context,
              );
            }
          },
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppStyle.tableTextFontSize,
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
      ],
    );
  }
}
