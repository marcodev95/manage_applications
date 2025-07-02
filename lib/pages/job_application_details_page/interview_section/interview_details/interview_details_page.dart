import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_panel_button_widget.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/get_interview_details_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_data_form.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_details.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_follow_ups_section/interview_follow_ups_section.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_monitoring_section/interview_timeline_section.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_interview_section.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

/// https://dribbble.com/shots/21537710-Matchday-Jobmatching-with-AI
/// https://dribbble.com/tags/schedule-interview
/// https://dribbble.com/shots/24119511-AR-Office-Software
/// https://dribbble.com/shots/25537125-Tiimi-Candidate-Details-and-Job-Interviews-in-SaaS-HRM
///

class InterviewDetailsPage extends ConsumerWidget {
  const InterviewDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [ErrorsPanelButtonWidget ()],
          title: const Text('Dettagli del colloquio'),
          bottom: TabBar(
            onTap: (int? index) {
              if (index != null) {
                ref.read(_currentIndexProvider.notifier).state = index;
              }
            },
            tabs: _tabs,
          ),
        ),
        body: InterviewDetailsPageBody(),
      ),
    );
  }

  List<Tab> get _tabs => [
    Tab(text: 'Dettagli del colloquio'),
    Tab(text: 'Referenti associati al colloquio'),
    Tab(text: 'Follow-Ups inviati'),
    Tab(text: 'Timeline colloquio'),
  ];
}

class InterviewDetailsPageBody extends ConsumerWidget {
  const InterviewDetailsPageBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeID = getRouteArg<int?>(context);

    debugPrint('RouteID => $routeID');

    if (routeID == null) {
      return Padding(
        padding: EdgeInsets.all(AppStyle.pad24),
        child: _PageTabsWidget(InterviewDetails.defaultValue()),
      );
    }

    final interviewDetailsAsync = ref.watch(
      getInterviewDetailsProvider(routeID),
    );
    ref.listenOnErrorWithoutSnackbar(
      provider: getInterviewDetailsProvider(routeID),
      context: context,
    );

    return interviewDetailsAsync.when(
      data:
          (result) => Padding(
            padding: EdgeInsets.all(AppStyle.pad24),
            child: _PageTabsWidget(result),
          ),
      error:
          (_, __) => DataLoadErrorScreenWidget(
            appBarTitle: 'Errore di caricamento',
            onPressed: () {
              ref.invalidate(getInterviewDetailsProvider(routeID));
            },
          ),

      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _PageTabsWidget extends ConsumerWidget {
  const _PageTabsWidget(this.details);

  final InterviewDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IndexedStack(
      index: ref.watch(_currentIndexProvider),
      children: [
        AppCard(child: InterviewDataForm(details.interview)),
        SelectedReferentsInterviewSection(),
        InterviewFollowUpsSection(),
        InterviewTimelineSection(),
      ],
    );
  }
}

final _currentIndexProvider = StateProvider.autoDispose((_) => 0);
