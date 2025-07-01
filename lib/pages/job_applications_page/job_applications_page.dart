import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/job_application_details_page.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/pages/job_applications_page/job_applications_table/job_applications_table.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';
import 'package:manage_applications/providers/job_application_filter.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/components/header_card_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class JobApplicationsPage extends StatelessWidget {
  const JobApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppStyle.pad24),
      child: Column(
        spacing: 40.0,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_FlterButtonsWidget()],
          ),

          Flexible(
            child: SingleChildScrollView(
              child: HeaderCardWidget(
                titleLabel: 'Lista candidature',
                trailing: _AddNewButton(),
                cardBody: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppStyle.pad16),
                  child: JobApplicationsTable(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddNewButton extends ConsumerWidget {
  const _AddNewButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButtonWidget(
      backgroundColor: Colors.blue,
      onPressed: () {
        ref.read(jobApplicationId.notifier).state = 0;
        navigatorPush(context, const JobApplicationDetailsPage());
      },
      label: "Nuova candidatura",
    );
  }
}

class _FlterButtonsWidget extends ConsumerStatefulWidget {
  const _FlterButtonsWidget();

  @override
  ConsumerState<_FlterButtonsWidget> createState() =>
      _FlterButtonsWidgetState();
}

class _FlterButtonsWidgetState extends ConsumerState<_FlterButtonsWidget> {
  final ValueNotifier<ApplicationFilter> selectedFilter = ValueNotifier(
    ApplicationFilter.all,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedFilter,
      builder: (_, value, __) {
        return SegmentedButton<ApplicationFilter>(
          segments: [
            ButtonSegment(
              value: ApplicationFilter.all,
              label: Text('Tutti le candidature'),
            ),
            ButtonSegment(
              value: ApplicationFilter.apply,
              label: Text('Candidato'),
            ),
            ButtonSegment(
              value: ApplicationFilter.interview,
              label: Text('Colloquio'),
            ),
            ButtonSegment(
              value: ApplicationFilter.pendingResponse,
              label: Text('In attesa'),
            ),
            ButtonSegment(
              value: ApplicationFilter.bookmark,
              label: Text('Salvati'),
            ),
          ],

          selected: {value},
          onSelectionChanged: (nv) {
            selectedFilter.value = nv.first;
            ref.read(applicationFilterProvider.notifier).state = nv.first;
          },
          multiSelectionEnabled: false,
          style: SegmentedButton.styleFrom(
            backgroundColor: Colors.grey[800], // sfondo dei bottoni
            foregroundColor: Colors.white70, // testo non selezionato
            selectedBackgroundColor: _selectedBgColor(
              value,
            ), // sfondo selezionato
            selectedForegroundColor: Colors.white, // testo selezionato
            side: const BorderSide(color: Colors.white24), // bordo dei bottoni
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }

  Color _selectedBgColor(ApplicationFilter value) {
    return switch (value) {
      ApplicationFilter.all => FilterColor.all,
      ApplicationFilter.interview => FilterColor.interview,
      ApplicationFilter.pendingResponse => FilterColor.pendingResponse,
      ApplicationFilter.apply => FilterColor.apply,
      ApplicationFilter.bookmark => FilterColor.bookmark,
    };
  }
}
