import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/interview_timeline_list.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';

class InterviewTimelineSection extends StatelessWidget {
  const InterviewTimelineSection(this.routeID, {super.key});

  final int? routeID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppStyle.pad16),
      child: Column(
        children: [
          SectionTitle('Storico della selezione'),
          const Divider(thickness: 1),
          Flexible(child: InterviewTimelineList(routeID: routeID)),
        ],
      ),
    );
  }
}
