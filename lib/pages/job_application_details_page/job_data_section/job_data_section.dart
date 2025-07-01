import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_form.dart';
import 'package:flutter/material.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';

class JobDataSection extends StatelessWidget {
  const JobDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionWidget(
      title: 'Dettagli annuncio lavoro',
      body: JobDataForm(),
    );
  }
}
