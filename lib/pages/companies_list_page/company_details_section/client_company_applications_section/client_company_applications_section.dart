import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/client_company_applications_section/client_company_applications_provider.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/company_job_applications_list.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class ClientCompanyApplicationsSection extends ConsumerWidget {
  const ClientCompanyApplicationsSection(this.companyId, {super.key});

  final int companyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobApplicationsAsync = ref.watch(
      clientCompanyApplicationsProvider(companyId),
    );

    return jobApplicationsAsync.when(
      data:
          (applications) => CompanyJobApplicationsList(
            applications: applications,
            button:
                (jobApplication) => _removeAssociation(
                  ref,
                  jobApplication.id,
                  context,
                  companyId,
                ),
          ),
      error: (_, __) {
        return DataLoadErrorScreenWidget(
          onPressed:
              () =>
                  ref.invalidate(clientCompanyApplicationsProvider(companyId)),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _removeAssociation(
    WidgetRef ref,
    int id,
    BuildContext context,
    int companyId,
  ) async {
    final notifier = ref.read(
      clientCompanyApplicationsProvider(companyId).notifier,
    );
    final result = await notifier.removeAssociation(id, companyId);

    if (!context.mounted) return;

    result.handleErrorResult(context: context, ref: ref);
  }
}
