import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/contract/benefit.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/benefits_section/benefits_form.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/benefits_section/benefits_notifier.dart';
import 'package:manage_applications/widgets/components/item_list_with_actions_widget.dart.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArg = getRouteArg<int?>(context);
    return SingleChildScrollView(
      primary: false,
      child: Column(
        children: [
          SectionWidget(
            title: 'Inserisci nuovo benefit',
            body: BenefitsForm(routeArg: routeArg),
          ),

          SectionWidget(
            externalPadding: const EdgeInsets.symmetric(
              horizontal: AppStyle.pad24,
            ),
            title: 'Lista dei benefits',
            body: SizedBox(height: 300.0, child: _BenefitsList(routeArg)),
          ),
        ],
      ),
    );
  }
}

class _BenefitsList extends ConsumerWidget {
  const _BenefitsList(this.routeArg);

  final int? routeArg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final benefitsAsync = ref.watch(benefitsProvider(routeArg));
    return benefitsAsync.when(
      skipLoadingOnReload: true,
      skipError: true,
      data:
          (benefits) => ItemListWithActionsWidget(
            items: benefits,
            itemToString: (b) => b.benefit,
            editCallback:
                (benefit) => _showEditDialog(context, benefit, routeArg),
            deleteCallback:
                (benefit) => _delete(ref, context, benefit.id!, routeArg),
          ),
      error:
          (_, __) => DataLoadErrorScreenWidget(
            onPressed: () => ref.invalidate(benefitsProvider),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _delete(
    WidgetRef ref,
    BuildContext context,
    int id,
    int? routeArg,
  ) async {
    final result = await ref
        .read(benefitsProvider(routeArg).notifier)
        .deleteBenefit(id);

    if (!context.mounted) return;

    result.handleErrorResult(context: context, ref: ref);
  }

  void _showEditDialog(BuildContext context, Benefit benefit, int? routeArg) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Modifica beneficio'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 500, maxWidth: 700),
            child: BenefitsForm(benefit: benefit, routeArg: routeArg),
          ),
        );
      },
    );
  }
}
