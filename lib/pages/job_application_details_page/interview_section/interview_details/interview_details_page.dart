import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/provider/get_interview_details_provider.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_data_form.dart';
import 'package:manage_applications/models/interview/interview_details.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_follow_ups_section/interview_follow_ups_section.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_monitoring_section/interview_timeline_section.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/selected_referents_interview_section/selected_referents_interview_section.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_panel_button_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class InterviewDetailsPage extends ConsumerWidget {
  const InterviewDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [ErrorsPanelButtonWidget()],
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
    final routeArg = getRouteArg<int?>(context);

    debugPrint('routeArg => $routeArg');

    if (routeArg == null) {
      return Padding(
        padding: EdgeInsets.all(AppStyle.pad24),
        child: _PageTabsWidget(InterviewDetails.defaultValue()),
      );
    }

    final interviewDetailsAsync = ref.watch(
      getInterviewDetailsProvider(routeArg),
    );
    ref.listenOnErrorWithoutSnackbar(
      provider: getInterviewDetailsProvider(routeArg),
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
            onPressed: () {
              ref.invalidate(getInterviewDetailsProvider(routeArg));
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
