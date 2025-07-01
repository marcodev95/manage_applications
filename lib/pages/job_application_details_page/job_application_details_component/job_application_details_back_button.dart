import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/are_job_application_id_and_company_id_present.dart';
import 'package:manage_applications/pages/job_application_details_page/providers/fetch_job_application_details_provider.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';

class JobApplicationDetailsBackButton extends ConsumerWidget {
  const JobApplicationDetailsBackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(areJobApplicationIdAndCompanyIdPresent);

    void onPressedHandler() {
      final fetchState = ref.read(fetchJobApplicationDetailsProvider);
      bool isFetchError = fetchState.hasError;

      if (!isActive && !isFetchError) {
        showErrorSnackBar(
          message:
              "Inserire azienda e/o dati della candidatura per tornare indietro",
          context: context,
        );
        return;
      }

      Navigator.pop(context);
    }

    return BackButton(onPressed: onPressedHandler);
  }
}
