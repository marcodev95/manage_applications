import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/applications_related_main_company_section/applications_related_main_company_notifier.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/related_job_applications_table_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class ApplicationsRelatedMainCompany extends ConsumerWidget {
  const ApplicationsRelatedMainCompany(this.companyId, {super.key});

  final int companyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobApplicationsList = ref.watch(
      applicationsRelatedMainCompanyProvider(companyId),
    );

    return jobApplicationsList.when(
      data:
          (applications) => RelatedJobApplicationsTableWidget(
            applications: applications,
            button: (jobData) => _delete(ref, jobData.id!, context),
          ),
      error: (error, stackTrace) {
        debugPrintErrorUtility(error, stackTrace);

        return DataLoadErrorScreenWidget(
          onPressed:
              () => ref.invalidate(applicationsRelatedMainCompanyProvider),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _delete(WidgetRef ref, int id, BuildContext context) async {
    final notifier = ref.read(
      applicationsRelatedMainCompanyProvider(companyId).notifier,
    );
    final result = await notifier.deleteJobApplication(id);

    if (!context.mounted) return;

    result.handleErrorResult(context: context, ref: ref);
  }
}
