import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/are_job_application_id_and_company_id_present.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_details_page.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interviews_list.dart';
import 'package:flutter/material.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewSection extends StatelessWidget {
  const InterviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppStyle.pad24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle('Elenco colloqui', trailing: _AddInterviewButton()),
          const Divider(thickness: 1),
          Expanded(child: InterviewsList()),
        ],
      ),
    );
  }
}

class _AddInterviewButton extends ConsumerWidget {
  const _AddInterviewButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(areJobApplicationIdAndCompanyIdPresent);

    return TextButtonWidget(
      onPressed:
          isActive
              ? () => navigatorPush(context, const InterviewDetailsPage())
              : () {},
      label: 'Aggiungi colloquio',
      isEnable: isActive,
    );
  }
}
