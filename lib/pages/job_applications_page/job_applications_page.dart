import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/job_application_details_page.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/pages/job_applications_page/job_applications_grid/job_applications_grid.dart';
import 'package:manage_applications/providers/job_application_filter.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class JobApplicationsPage extends StatelessWidget {
  const JobApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppStyle.pad24),
      child: Column(
        spacing: 20.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 20,
            children: [Expanded(child: _FlterButtons()), _AddNewApplicationBtn()],
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppStyle.pad16),
              child: JobApplicationsGrid(),
            ),
          ),

        ],
      ),
    );
  }
}

class _AddNewApplicationBtn extends ConsumerWidget {
  const _AddNewApplicationBtn();

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

class _FlterButtons extends ConsumerStatefulWidget {
  const _FlterButtons();

  @override
  ConsumerState<_FlterButtons> createState() =>
      _FlterButtonsState();
}

class _FlterButtonsState extends ConsumerState<_FlterButtons> {
  final ValueNotifier<ApplicationFilter> selectedFilter = ValueNotifier(
    ApplicationFilter.all,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedFilter,
      builder: (_, value, __) {
        return SegmentedButton<ApplicationFilter>(
          segments: const [
            ButtonSegment(
              value: ApplicationFilter.all,
              label: Text(
                'Tutte le candidature',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
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
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white70,
            selectedBackgroundColor: _selectedBgColor(value),
            selectedForegroundColor: Colors.white,
            side: const BorderSide(color: Colors.white24),
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
