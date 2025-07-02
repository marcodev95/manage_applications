import 'package:manage_applications/pages/job_application_details_page/job_application_details_component/job_application_details_component_barrel.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/are_job_application_id_and_company_id_present.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_panel_button_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/job_application_sections_barrel.dart';
import 'package:manage_applications/widgets/components/side_navigation_rail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class JobApplicationDetailsPage extends StatelessWidget {
  const JobApplicationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _PageTitle(),
        leading: const JobApplicationDetailsBackButton(),
        actions: const [ErrorsPanelButtonWidget ()],
      ),
      body: const _JobApplicationDetailsPageBody(),
    );
  }
}

class _PageTitle extends ConsumerWidget {
  const _PageTitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = ref.watch(areJobApplicationIdAndCompanyIdPresent);

    return Text(isEdit ? 'Modifica candidatura' : 'Nuovo candidatura');
  }
}

class _JobApplicationDetailsPageBody extends ConsumerWidget {
  const _JobApplicationDetailsPageBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenOnErrorWithoutSnackbar(
      provider: fetchJobApplicationDetailsProvider,
      context: context,
    );

    final applicationDetailsAsync = ref.watch(
      fetchJobApplicationDetailsProvider,
    );

    return applicationDetailsAsync.when(
      data: (_) => const _PageBody(),
      error: (_, __) {
        return DataLoadErrorScreenWidget(
          onPressed: () => ref.invalidate(fetchJobApplicationDetailsProvider),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody();

  @override
  Widget build(BuildContext context) {
    return const SideNavigationRailWidget(
      pages: [
        JobDataSection(),
        CompanySection(),
        InterviewSection(),
        ContractSection(),
        RequirementSection(),
      ],
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.description),
          label: Text("Dati candidatura"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.business_center),
          label: Text("Dati azienda"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.phone_callback),
          label: Text("Colloqui"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.euro),
          label: Text("Contratto"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.list),
          label: Text("Requisiti"),
        ),
      ],
      labelType: NavigationRailLabelType.selected,
    );
  }
}