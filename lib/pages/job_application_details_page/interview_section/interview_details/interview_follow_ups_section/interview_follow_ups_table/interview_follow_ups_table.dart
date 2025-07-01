import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_follow_ups_section/interview_follow_ups_controller.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewFollowUpsTable extends ConsumerWidget {
  const InterviewFollowUpsTable(this.onEdit, {super.key});

  final void Function(InterviewFollowUp) onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeId = getRouteArg<int?>(context);

    final asyncFollowUps = ref.watch(interviewFollowUpsController(routeId));

    return asyncFollowUps.when(
      skipError: true,
      skipLoadingOnReload: true,
      data:
          (data) => TableWidget(
            columns: [
              dataColumnWidget('Tipo followUp'),
              dataColumnWidget('Data followUp'),
              dataColumnWidget('Risposta'),
              dataColumnWidget('Azioni'),
            ],
            dataRow: buildColoredRow(
              list: data,
              cells:
                  (followUp, _) => [
                    DataCell(
                      Text(
                        followUp.followUpType,
                        style: TextStyle(fontSize: AppStyle.tableTextFontSize),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 150.0,
                        child: Text(
                          uiFormat.format(followUp.followUpDate),
                          style: TextStyle(
                            fontSize: AppStyle.tableTextFontSize,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 150.0,
                        child: Row(
                          spacing: 8,
                          children: [
                            followUp.responseReceived.icon,
                            Text(
                              followUp.responseReceived.displayName,
                              style: TextStyle(
                                fontSize: AppStyle.tableTextFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      Wrap(
                        children: [
                          _EditFollowUpButton(() => onEdit(followUp)),
                          _DeleteFollowUpButton(followUp, routeId),
                        ],
                      ),
                    ),
                  ],
            ),
          ),

      error: (e, st) => Text('$e'),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

class _EditFollowUpButton extends ConsumerWidget {
  const _EditFollowUpButton(this.onEdit);

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: onEdit,
      icon: const Icon(Icons.edit, color: Colors.amber),
    );
  }
}

class _DeleteFollowUpButton extends ConsumerWidget {
  const _DeleteFollowUpButton(this.followUp, this.interviewId);

  final InterviewFollowUp followUp;
  final int? interviewId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading =
        ref.watch(interviewFollowUpsController(interviewId)).isLoading;

    return isLoading
        ? CircularProgressIndicator()
        : IconButton(
          onPressed: () async {
            final result = await ref
                .read(interviewFollowUpsController(interviewId).notifier)
                .deleteFollowUp(followUp);
            if (!context.mounted) return;

            result.handleResult(context: context, ref: ref);
          },
          icon: const Icon(Icons.delete, color: Colors.red),
        );
  }
}
