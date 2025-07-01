import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/providers/delete_company_provider.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/providers/is_company_deletable_provider.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class DeleteCompanyButton extends ConsumerWidget {
  const DeleteCompanyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(
      isCompanyDeletableProvider(getRouteArg(context)),
    );

    return isVisible
        ? RemoveButtonWidget(
          onPressed: () async {
            final controller = await ref.read(
              deleteCompanyController(getRouteArg<int?>(context)).future,
            );

            if (!context.mounted) return;

            controller.handleErrorResult(context: context, ref: ref);

            if (controller.isSuccess) Navigator.pop(context);
          },
        )
        : const SizedBox();
  }
}
