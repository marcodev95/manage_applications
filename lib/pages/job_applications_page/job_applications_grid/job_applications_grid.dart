import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/widgets/components/button/details_button_widget.dart';
import 'package:manage_applications/widgets/components/button/open_link_button_widget.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'job_applications_grid_barrel.dart';

class JobApplicationsGrid extends ConsumerWidget {
  const JobApplicationsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenOnErrorWithoutSnackbar(
      provider: paginatorApplicationsUIProvider,
      context: context,
    );

    final paginatorAsync = ref.watch(paginatorApplicationsUIProvider);

    return paginatorAsync.when(
      skipLoadingOnReload: true,
      skipError: true,
      data:
          (paginator) => Column(
            spacing: 10.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: _JobApplicationsBody(paginator.items)),

              const DividerWidget(),

              PaginatorWidget(
                paginatorState: paginator,
                previousPage: () => _previousPage(ref),
                nextPage: () => _nextPage(ref),
              ),
            ],
          ),

      error: (_, __) {
        return DataLoadErrorScreenWidget(
          onPressed: () => ref.invalidate(paginatorApplicationsUIProvider),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void _previousPage(WidgetRef ref) =>
      ref.read(paginatorApplicationsUIProvider.notifier).goBack();

  void _nextPage(WidgetRef ref) =>
      ref.read(paginatorApplicationsUIProvider.notifier).nextPage();
}

class _JobApplicationsBody extends ConsumerWidget {
  const _JobApplicationsBody(this.applicationsUI);

  final List<JobApplicationUi> applicationsUI;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: applicationsUI.length,
      itemBuilder: (context, index) {
        final application = applicationsUI[index];
        final appId = application.id!;
        final applicationStatus = application.applicationStatus;

        return SizedBox(
          width: double.infinity,
          height: 330,
          child: AppCard(
            externalPadding: const EdgeInsets.all(AppStyle.pad16),
            internalPadding: const EdgeInsets.all(AppStyle.pad24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ApplicationStatusBadge(applicationStatus),
                const SizedBox(height: 15.0),

                _WorkPositionRow(application.position),
                const SizedBox(height: 10.0),

                _CompanyNameRow(application.companyRef?.name),
                _WorkPlaceRow(application),
                const SizedBox(height: 15.0),

                _ApplicationSendDate(application.applyDate),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: DividerWidget(),
                ),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final mainAxisAlignment =
                        width < 500
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.end;
                    return Row(
                      spacing: 10.0,
                      mainAxisAlignment: mainAxisAlignment,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DetailsButtonWidget(
                          onPressed: () => _openDetails(ref, context, appId),
                        ),
                        OpenLinkButtonWidget(
                          onPressed: () => _openUrl(context, application.link),
                        ),
                        RemoveButtonWidget(
                          onPressed:
                              () => _deleteApplication(ref, context, appId),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openDetails(WidgetRef ref, BuildContext context, int id) {
    ref.invalidate(jobApplicationIdProvider);
    ref.read(jobApplicationIdProvider.notifier).state = id;
    navigatorPush(context, const JobApplicationDetailsPage());
  }

  Future<void> _deleteApplication(
    WidgetRef ref,
    BuildContext context,
    int id,
  ) async {
    final delete = await ref
        .read(paginatorApplicationsUIProvider.notifier)
        .deleteJobApplication(id);

    if (!context.mounted) return;

    delete.handleResult(context: context, ref: ref);
  }

  Future<void> _openUrl(BuildContext context, String link) async {
    await tryToLaunchUrl(context: context, link: link);
  }
}

class _WorkPositionRow extends StatelessWidget {
  const _WorkPositionRow(this.position);

  final String position;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        const Icon(Icons.work_outline),
        Flexible(
          child: Text(
            position,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _ApplicationStatusBadge extends StatelessWidget {
  const _ApplicationStatusBadge(this.applicationStatus);

  final ApplicationStatus applicationStatus;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: applicationStatus.displayChipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Text(
          applicationStatus.displayName,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _CompanyNameRow extends StatelessWidget {
  const _CompanyNameRow(this.name);

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        const Icon(Icons.business_rounded, size: 16),
        Flexible(
          child: Text(
            name ?? '',
            style: const TextStyle(fontSize: AppStyle.tableTextFontSize),
          ),
        ),
      ],
    );
  }
}

class _WorkPlaceRow extends StatelessWidget {
  const _WorkPlaceRow(this.application);
  final JobApplicationUi application;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        const Icon(Icons.location_on_outlined, size: 16),
        Flexible(
          child: Text(
            _buildWorkPlaceAndType(application),
            style: const TextStyle(fontSize: AppStyle.tableTextFontSize),
          ),
        ),
      ],
    );
  }

  String _buildWorkPlaceAndType(JobApplicationUi application) {
    final workType = application.workType;
    final workTypeName = workType.displayName;
    final workPlace = application.workPlace;

    return workType.isRemote ? workTypeName : '$workPlace - $workTypeName';
  }
}

class _ApplicationSendDate extends StatelessWidget {
  const _ApplicationSendDate(this.applyDate);

  final DateTime applyDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
        Flexible(
          child: Text(
            'Candidatura inviata il: ${uiFormat.format(applyDate)}',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ),
      ],
    );
  }
}