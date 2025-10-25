import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/main_company_applications_section/main_company_applications_provider.dart';
import 'package:manage_applications/pages/companies_list_page/company_details_section/company_job_applications_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class MainCompanyApplicationsSection extends ConsumerWidget {
  const MainCompanyApplicationsSection(this.companyId, {super.key});

  final int companyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobApplicationsAsync = ref.watch(
      mainCompanyApplicationsProvider(companyId),
    );

    return jobApplicationsAsync.when(
      data:
          (applications) => CompanyJobApplicationsList(
            applications: applications,
            button:
                (jobApplication) => _delete(ref, jobApplication.id, context),
            isMainCompany: true,
          ),
      error: (e, st) {
        return DataLoadErrorScreenWidget(
          onPressed:
              () => ref.invalidate(mainCompanyApplicationsProvider(companyId)),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _delete(WidgetRef ref, int id, BuildContext context) async {
    final notifier = ref.read(
      mainCompanyApplicationsProvider(companyId).notifier,
    );
    final result = await notifier.deleteJobApplication(id);

    if (!context.mounted) return;

    result.handleErrorResult(context: context, ref: ref);
  }
}
