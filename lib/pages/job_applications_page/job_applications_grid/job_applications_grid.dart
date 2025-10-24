import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 item per riga
        childAspectRatio: 2.2, // Rapporto tra larghezza e altezza della card
      ),
      itemCount: applicationsUI.length,
      itemBuilder: (context, index) {
        final application = applicationsUI[index];
        final applicationStatus = application.applicationStatus;

        return AppCard(
          externalPadding: const EdgeInsets.all(AppStyle.pad16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: applicationStatus.displayChipColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 12.0,
                      ),
                      child: Text(
                        applicationStatus.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  _popupMenuButtonWidget(application, context, ref),
                ],
              ),
              Flexible(
                child: Text(
                  application.position,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              Flexible(
                child: Text(
                  application.companyRef?.name ?? '',
                  style: const TextStyle(fontSize: AppStyle.tableTextFontSize),
                ),
              ),
              Flexible(
                child: Text(
                  _buildWorkPlaceAndType(application),
                  style: const TextStyle(fontSize: AppStyle.tableTextFontSize),
                ),
              ),
              const SizedBox(height: 10.0),
              Flexible(
                child: Text(
                  'Candidatura inviata il: ${uiFormat.format(application.applyDate)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PopupMenuButtonWidget _popupMenuButtonWidget(
    JobApplicationUi application,
    BuildContext context,
    WidgetRef ref,
  ) {
    return PopupMenuButtonWidget<String>(
      popupMenuEntry: [
        PopupMenuItem(
          value: "edit",
          child: const Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.description_sharp, color: Colors.amber),
              Text('Dettagli della candidatura'),
            ],
          ),
          onTap: () {
            ref.read(jobApplicationIdProvider.notifier).state = application.id!;
            navigatorPush(context, const JobApplicationDetailsPage());
          },
        ),
        PopupMenuItem<String>(
          value: "delete",
          child: const Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.red),
              Text('Elimina candidatura'),
            ],
          ),
          onTap: () async {
            final delete = await ref
                .read(paginatorApplicationsUIProvider.notifier)
                .deleteJobApplication(application.id!);

            if (!context.mounted) return;

            delete.handleResult(context: context, ref: ref);
          },
        ),
        PopupMenuItem<String>(
          value: "url",
          child: const Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.link, color: Colors.blue),
              Text('Vai all\'annuncio'),
            ],
          ),
          onTap: () {},
        ),
      ],
    );
  }
}

String _buildWorkPlaceAndType(JobApplicationUi application) {
  final workType = application.workType;
  final workTypeName = workType.displayName;
  final workPlace = application.workPlace;

  return workType.isRemote ? workTypeName : '$workPlace - $workTypeName';
}
