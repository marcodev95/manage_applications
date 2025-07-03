import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/providers/is_company_deletable_provider.dart';
import 'package:manage_applications/providers/companies_paginator_notifier.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class DeleteCompanyButton extends ConsumerWidget {
  const DeleteCompanyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeArg = getRouteArg(context);
    final isVisible = ref.watch(isCompanyDeletableProvider(routeArg));

    return isVisible
        ? RemoveButtonWidget(
          onPressed: () async {
            final notifier = ref.read(companiesPaginatorProvider.notifier);
            final result = await notifier.deleteCompany(routeArg);

            if (!context.mounted) return;

            result.handleErrorResult(context: context, ref: ref);

            if (result.isSuccess) Navigator.pop(context);
          },
        )
        : const SizedBox();
  }
}
