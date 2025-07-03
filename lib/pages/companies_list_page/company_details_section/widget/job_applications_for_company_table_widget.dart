import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/job_data/job_application_ui.dart';
import 'package:manage_applications/pages/job_applications_page/job_application_status_chip.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:flutter/material.dart';

class JobApplicationsForCompanyTableWidget extends StatelessWidget {
  const JobApplicationsForCompanyTableWidget({
    super.key,
    required this.applications,
    required this.button,
  });

  final List<JobApplicationUi> applications;
  final void Function(JobApplicationUi) button;

  @override
  Widget build(BuildContext context) {
    return TableWidget(
      columns: [
        dataColumnWidget('Posizione'),
        dataColumnWidget('Data candidatura'),
        dataColumnWidget('Stato'),
        dataColumnWidget('Azioni'),
      ],
      dataRow: buildColoredRow(
        list: applications,
        cells:
            (ad, _) => [
              DataCell(
                Text(
                  ad.position,
                  style: const TextStyle(fontSize: AppStyle.tableTextFontSize),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100.0,
                  child: Text(
                    uiFormat.format(ad.applyDate),
                    style: const TextStyle(
                      fontSize: AppStyle.tableTextFontSize,
                    ),
                  ),
                ),
              ),
              DataCell(
                JobApplicationStatusChip(
                  applicationStatus: ad.applicationStatus,
                ),
              ),
              DataCell(RemoveButtonWidget(onPressed: () => button(ad))),
            ],
      ),
    );
  }
}
