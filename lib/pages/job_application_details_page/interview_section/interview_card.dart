import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_details_page.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interviews_provider.dart';
import 'package:manage_applications/widgets/components/button/details_button_widget.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewCard extends ConsumerWidget {
  const InterviewCard(this.interviewUi, {super.key});

  final InterviewUi interviewUi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      externalPadding: EdgeInsets.symmetric(vertical: AppStyle.pad16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Tooltip(
                  message: 'Tipo di colloquio',
                  child: Icon(
                    interviewUi.type.interviewTypeIcon,
                    color: Colors.green,
                  ),
                ),
                Text(
                  interviewUi.type.displayName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Tooltip(
                  message: 'Data e ora del colloquio',
                  child: Icon(Icons.event, color: Colors.blue),
                ),
                Text(
                  _displayOriginalDateTime(context),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    decoration: _isLineThrough,
                  ),
                ),

                if (_isRescheduled) _rescheduledBadge(),
              ],
            ),
            Row(
              spacing: 40,
              children: [
                Expanded(
                  child: Row(
                    spacing: 8,
                    children: [
                      Tooltip(
                        message: 'Tempo di risposta',
                        child: Icon(Icons.access_time, color: Colors.grey),
                      ),
                      Text(
                        interviewUi.answerTime ?? 'Da definire',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[300], thickness: 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    spacing: 100,
                    children: [
                      _BuildPlaceSection(interviewUi),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Text('Stato', style: TextStyle(fontSize: 16)),
                          Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.circle,
                                color: interviewUi.status.iconColor,
                                size: 20,
                              ),
                              Text(
                                interviewUi.status.displayName,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  spacing: 12.0,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _GoToInterviewDetailsButton(interviewUi.id!),
                    _DeleteInterviewButton(interviewUi.id!),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rescheduledBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 16, color: Colors.orange),
          SizedBox(width: 4),
          Text(
            'Colloquio rinviato',
            style: TextStyle(
              color: Colors.orange[800],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4),

          Text(
            dateTimeFormatUI.format(interviewUi.rescheduleDateTime!),
            style: TextStyle(
              color: Colors.orange[800],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  bool get _isRescheduled => interviewUi.rescheduleDateTime != null;

  bool get _isCancelled => interviewUi.status == InterviewStatus.cancelled;

  TextDecoration? get _isLineThrough =>
      _isRescheduled || _isCancelled ? TextDecoration.lineThrough : null;

  String _displayOriginalDateTime(BuildContext context) {
    return "${uiFormat.format(interviewUi.date)} - ${interviewUi.time.format(context)}";
  }
}

class _DeleteInterviewButton extends ConsumerWidget {
  const _DeleteInterviewButton(this.id);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RemoveButtonWidget(
      onPressed: () async {
        final delete = await ref
            .read(interviewsProvider.notifier)
            .deleteInterview(id);

        if (!context.mounted) return;

        delete.handleErrorResult(context: context, ref: ref);
      },
    );
  }
}

class _GoToInterviewDetailsButton extends StatelessWidget {
  const _GoToInterviewDetailsButton(this.id);

  final int id;

  @override
  Widget build(BuildContext context) {
    return DetailsButtonWidget(
      onPressed:
          () => navigatorPush(context, InterviewDetailsPage(routeID: id)),
    );
  }
}

String _interviewPlace(InterviewUi interview, WidgetRef ref) {
  if (interview.interviewFormat == InterviewsFormat.telefono) {
    return interview.interviewFormat.displayName;
  }

  return '${interview.interviewFormat.displayName} - ${interview.interviewPlace}';
}

class ReschedulePlace extends StatelessWidget {
  const ReschedulePlace(this.newPlace, {super.key});

  final String newPlace;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.place, color: Colors.redAccent),
        SizedBox(width: 4),
        Tooltip(
          message: 'Il luogo del colloquio è stato aggiornato',
          child: Text(newPlace),
        ),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "Luogo aggiornato",
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _BuildPlaceSection extends ConsumerWidget {
  const _BuildPlaceSection(this.iu);

  final InterviewUi iu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Luogo del colloquio', style: TextStyle(fontSize: 16)),
        iu.placeUpdated
            ? ReschedulePlace(iu.interviewPlace!)
            : Text(
              _interviewPlace(iu, ref),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
      ],
    );
  }
}


/* Row(
  children: [
    Icon(Icons.place, color: Colors.redAccent),
    SizedBox(width: 4),
    Tooltip(
      message: 'Il luogo del colloquio è stato aggiornato',
      child: Text("Via Roma 12, Milano"),
    ),
    SizedBox(width: 8),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "Luogo aggiornato",
        style: TextStyle(fontSize: 10, color: Colors.black),
      ),
    )
  ],
)
 */