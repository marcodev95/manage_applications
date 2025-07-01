import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/applications_related_client_company_section/applications_related_client_company_notifier.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/related_job_applications_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class ApplicationsRelatedClientCompanySectionSection extends ConsumerWidget {
  const ApplicationsRelatedClientCompanySectionSection(
    this.companyId, {
    super.key,
  });

  final int companyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobApplicationsList = ref.watch(
      applicationsRelatedClientCompanyProvider(companyId),
    );

    return jobApplicationsList.when(
      data:
          (applications) => RelatedJobApplicationsTableWidget(
            applications: applications,
            button: (jobData) => _delete(ref, jobData.id!, context),
          ),
      error: (_, __) {
        return DataLoadErrorScreenWidget(
          onPressed:
              () => ref.invalidate(applicationsRelatedClientCompanyProvider),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _delete(WidgetRef ref, int id, BuildContext context) async {
    final notifier = ref.read(
      applicationsRelatedClientCompanyProvider(companyId).notifier,
    );
    final result = await notifier.removeAssociation(id);

    if (!context.mounted) return;

    result.handleErrorResult(context: context, ref: ref);
  }
}
