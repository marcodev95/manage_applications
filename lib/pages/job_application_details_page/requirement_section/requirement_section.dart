import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/requirement.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/requirement_section/requirement_form.dart';
import 'package:manage_applications/pages/job_application_details_page/requirement_section/requirements_provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_applications/widgets/components/item_list_with_actions_widget.dart.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class RequirementSection extends StatelessWidget {
  const RequirementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Column(
        children: [
          SectionWidget(
            title: 'Inserisci nuovo requisito',
            body: RequirementFormWidget(),
          ),

          SectionWidget(
            title: 'Lista dei requisiti',
            externalPadding: const EdgeInsets.symmetric(
              horizontal: AppStyle.pad24,
            ),
            body: Column(
              children: [SizedBox(height: 380.0, child: _RequirementsList())],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementsList extends ConsumerWidget {
  const _RequirementsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final benefitsAsync = ref.watch(requirementsProvider);

    ref.listenOnErrorWithoutSnackbar(
      provider: requirementsProvider,
      context: context,
    );

    return benefitsAsync.when(
      skipLoadingOnReload: true,
      skipError: true,
      data:
          (requirements) => ItemListWithActionsWidget(
            items: requirements,
            itemToString: (requirement) => requirement.requirement,
            editCallback: (value) => _showEditDialog(context, value),
            deleteCallback: (value) => _delete(ref, context, value.id!),
          ),
      error:
          (_, __) => DataLoadErrorScreenWidget(
            onPressed: () => ref.invalidate(requirementsProvider),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _delete(WidgetRef ref, BuildContext context, int id) async {
    final result = await ref
        .read(requirementsProvider.notifier)
        .deleteRequirement(id);

    if (!context.mounted) return;

    result.handleErrorResult(context: context, ref: ref);
  }

  void _showEditDialog(BuildContext context, Requirement requirement) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Modifica requisito'),
          content: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 500, maxWidth: 700),
            child: RequirementFormWidget(requirement: requirement),
          ),
        );
      },
    );
  }
}
