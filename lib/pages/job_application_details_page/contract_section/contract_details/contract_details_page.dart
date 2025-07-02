import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/provider/get_contract_details_provider.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/benefits_section/benefits_section.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/contract_form/contract_form_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class ContractDetailsPage extends ConsumerWidget {
  const ContractDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeArg = getRouteArg<int?>(context);

    final contractAsync = ref.watch(getContractDetailsProvider(routeArg));

    ref.listenOnErrorWithoutSnackbar(
      provider: getContractDetailsProvider(routeArg),
      context: context,
    );

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dettagli del contratto'),
          actions: const [ErrorsWidget()],
          bottom: TabBar(tabs: _tabs),
        ),
        body: contractAsync.when(
          data:
              (details) => TabBarView(
                children: [
                  ContractFormWidget(details.contract),
                  const BenefitsSection(),
                ],
              ),
          error: (_, __) {
            return DataLoadErrorScreenWidget(
              onPressed: () => ref.invalidate(getContractDetailsProvider),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  List<Tab> get _tabs => const [
    Tab(text: 'Dettagli del contratto'),
    Tab(text: 'Benefits'),
  ];
}
