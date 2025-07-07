import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_form.dart';
import 'package:flutter/material.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';

class JobApplicationSection extends StatelessWidget {
  const JobApplicationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionWidget(
      title: 'Dettagli candidatura',
      body: JobApplicationForm(),
    );
  }
}
