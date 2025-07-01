import 'package:manage_applications/models/requirement.dart';
import 'package:manage_applications/pages/job_application_details_page/requirement_section/change_requirement_screen_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/requirement_section/requirements_provider.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// https://stackoverflow.com/questions/67015162/builder-widget-for-changenotifier-in-flutter
/// https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html

class RequirementTable extends ConsumerWidget {
  const RequirementTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //Da togliere ?
    ref.listenOnErrorWithSnackbar(
      provider: requirementsProvider,
      context: context,
    );

    final asyncRequirements = ref.watch(requirementsProvider);

    return asyncRequirements.when(
      skipError: true,
      data:
          (data) => TableWidget(
            columns: const [
              DataColumn(
                label: SizedBox(width: 700.0, child: Text("Requisito")),
              ),
              DataColumn(label: Text('')),
            ],
            dataRow: createDataRowFromList(
              list: data,
              cells:
                  (requirement) => [
                    DataCell(
                      SizedBox(
                        width: 700.0,
                        child: Text(
                          requirement.requirement,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      TableButtonsWidget(
                        buttons: [
                          EditTableButton(requirement),
                          RemoveTableButton(requirement.id!),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
      error: (error, stackTrace) => Text('$error'),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

class EditTableButton extends ConsumerWidget {
  const EditTableButton(this.requirement, {super.key});

  final Requirement requirement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref
            .read(changeRequirementScreenProvider.notifier)
            .goToForm(requirement);
      },
      icon: Icon(Icons.edit, color: Colors.amber,),
    );
  }
}

class RemoveTableButton extends ConsumerWidget {
  const RemoveTableButton(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref.read(requirementsProvider.notifier).deleteRequirement(id);
      },
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }
}
