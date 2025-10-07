import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_barrel.dart';
import 'package:manage_applications/widgets/components/pop_up_menu_button_widget.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class CompanyReferentTable extends ConsumerWidget {
  const CompanyReferentTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referentsAsync = ref.watch(referentsProvider);

    return referentsAsync.when(
      skipError: true,
      skipLoadingOnReload: true,
      data:
          (data) => TableWidget(
            columns: const [
              DataColumn(label: Text("Nome")),
              DataColumn(label: Text("Ruolo")),
              DataColumn(label: Text("Azioni")),
            ],
            dataRow: buildColoredRow(
              list: data,
              cells: (r, _) {
                final referent = r.referentWithAffiliation.referent;
                return [
                  DataCell(CompanyReferentBadge(r.referentWithAffiliation)),
                  DataCell(
                    SizedBox(
                      width: 100.0,
                      child: Tooltip(
                        message: referent.role.displayName,
                        child: Text(
                          referent.role.displayName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    PopupMenuButtonWidget<String>(
                      popupMenuEntry: [
                        _editButton(context, referent.id!, ref),
                        _removeReferentFromJobApplication(
                          ref,
                          referent.id!,
                          context,
                        ),
                        _deleteButton(ref, referent.id!, context),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
      error:
          (_, __) => DataLoadErrorScreenWidget(
            onPressed: () => ref.invalidate(referentsProvider),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  PopupMenuItem<String> _editButton(
    BuildContext context,
    int id,
    WidgetRef ref,
  ) {
    return PopupMenuItem<String>(
      value: "edit",
      child: const Center(child: Icon(Icons.edit, color: Colors.amber)),
      onTap:
          () => ref
              .read(companyChangeScreenProvider.notifier)
              .goToReferentCompanyForm(id),
    );
  }

  PopupMenuItem<String> _deleteButton(
    WidgetRef ref,
    int id,
    BuildContext context,
  ) {
    return PopupMenuItem<String>(
      value: "delete",
      child: const Center(child: Icon(Icons.delete, color: Colors.red)),
      onTap: () async {
        final notifier = ref.read(referentsProvider.notifier);

        final delete = await notifier.deleteReferent(id);

        if (!context.mounted) return;

        delete.handleErrorResult(context: context, ref: ref);
      },
    );
  }

  PopupMenuItem<String> _removeReferentFromJobApplication(
    WidgetRef ref,
    int id,
    BuildContext context,
  ) {
    return PopupMenuItem<String>(
      value: "removeReferentFromJobApplication",
      child: Center(child: Icon(Icons.link_off, color: Colors.indigo.shade500)),
      onTap: () async {
        final notifier = ref.read(referentsProvider.notifier);

        final result = await notifier.unlinkReferentFromJobApplication(id);

        if (!context.mounted) return;

        result.handleErrorResult(context: context, ref: ref);
      },
    );
  }
}
