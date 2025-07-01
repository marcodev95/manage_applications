import 'package:flutter/material.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_utility.dart';

class JobApplicationStatusChip extends StatelessWidget {
  const JobApplicationStatusChip({super.key, required this.applicationStatus});

  final ApplicationStatus applicationStatus;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(applicationStatus.displayName),
      backgroundColor: applicationStatus.displayChipColor,
    );
  }
}
