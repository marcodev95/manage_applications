import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/job_entry/job_entry_summary.dart';
import 'package:manage_applications/pages/job_applications_page/job_applications_grid/job_applications_grid_barrel.dart';

class CompanyJobApplicationsList extends ConsumerWidget {
  const CompanyJobApplicationsList({
    super.key,
    required this.applications,
    required this.button,
  });

  final List<JobEntrySummary> applications;
  final void Function(JobEntrySummary) button;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        final status = application.status;

        return AppCard(
          externalPadding: const EdgeInsets.symmetric(vertical: AppStyle.pad8),
          child: Row(
            children: [
              // Colonna principale con titolo e cliente
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.position,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (application.clientCompanyName != null)
                      Text("Cliente: ${application.clientCompanyName}"),
                    if (application.mainCompanyName != null)
                      Text(
                        "Candidatura inoltrata a: ${application.mainCompanyName}",
                      ),
                  ],
                ),
              ),

              // Colonna con data invio
              Expanded(
                flex: 2,
                child: Text(
                  "Inviata il: ${uiFormat.format(application.applyDate)}",
                ),
              ),

              // Stato
              DecoratedBox(
                decoration: BoxDecoration(
                  color: status.displayChipColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 16,
                  ),
                  child: Text(
                    status.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Azioni
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.amber),
                    tooltip: 'Dettagli candidatura',
                    onPressed: () {
                      ref.read(jobApplicationIdProvider.notifier).state =
                          application.id;
                      navigatorPush(context, JobApplicationDetailsPage());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Elimina candidatura',
                    onPressed: () => button(application),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
