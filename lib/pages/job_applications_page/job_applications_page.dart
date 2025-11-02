import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/job_application_details_page.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/pages/job_applications_page/job_applications_grid/job_applications_grid.dart';
import 'package:manage_applications/providers/job_application_filter.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';
import 'package:manage_applications/widgets/components/button/text_button_widget.dart';
import 'package:manage_applications/widgets/components/pop_up_menu_button_widget.dart';
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
          _ResponsiveFilterButtons(),
          Expanded(child: JobApplicationsGrid()),
        ],
      ),
    );
  }
}

class _ResponsiveFilterButtons extends ConsumerWidget {
  const _ResponsiveFilterButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final isCompact = constraints.maxWidth < AppStyle.compactBreakpoint;

        return Stack(
          children: [
            Offstage(
              offstage: isCompact,
              child: const Row(
                spacing: 20,
                children: [
                  Expanded(child: _FilterButtons()),
                  _AddNewApplicationBtn(),
                ],
              ),
            ),

            Offstage(
              offstage: !isCompact,
              child: const _CompactFilterButtons(),
            ),
          ],
        );
      },
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
        ref.read(jobApplicationIdProvider.notifier).state = null;
        navigatorPush(context, const JobApplicationDetailsPage());
      },
      label: "Nuova candidatura",
    );
  }
}

class _FilterButtons extends ConsumerWidget {
  const _FilterButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(applicationFilterProvider);

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
        ButtonSegment(value: ApplicationFilter.apply, label: Text('Candidato')),
        ButtonSegment(
          value: ApplicationFilter.interview,
          label: Text('Colloquio'),
        ),
        ButtonSegment(
          value: ApplicationFilter.pendingResponse,
          label: Text('In attesa'),
        ),
      ],

      selected: {filter},
      onSelectionChanged: (nv) {
        ref.read(applicationFilterProvider.notifier).state = nv.first;
      },
      multiSelectionEnabled: false,
      style: SegmentedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white70,
        selectedBackgroundColor: _selectedBgColor(filter),
        selectedForegroundColor: Colors.white,
        side: const BorderSide(color: Colors.white24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
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

class _CompactFilterButtons extends ConsumerWidget {
  const _CompactFilterButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(applicationFilterProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _AddNewApplicationBtn(),
        PopupMenuButtonWidget<ApplicationFilter>(
          popupMenuEntry: [
            CheckedPopupMenuItem(
              value: ApplicationFilter.all,
              checked: filter == ApplicationFilter.all,
              child: const Text('Tutte le candidature'),
            ),
            CheckedPopupMenuItem(
              value: ApplicationFilter.apply,
              checked: filter == ApplicationFilter.apply,
              child: const Text('Candidato'),
            ),
            CheckedPopupMenuItem(
              value: ApplicationFilter.interview,
              checked: filter == ApplicationFilter.interview,
              child: const Text('Colloquio'),
            ),
            CheckedPopupMenuItem(
              value: ApplicationFilter.pendingResponse,
              checked: filter == ApplicationFilter.pendingResponse,
              child: const Text('In attesa'),
            ),
          ],
          onSelected: (value) {
            ref.read(applicationFilterProvider.notifier).state = value;
          },
        ),
      ],
    );
  }
}
