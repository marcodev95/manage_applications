import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/applied_company/applied_company_form_notifier.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_application_notifier.dart';

final areJobApplicationIdAndCompanyIdPresent = Provider.autoDispose<bool>(
  (ref) =>
      ref.watch(isJobApplicationIdPresent) && ref.watch(isCompanyIdPresent),
);

final isJobApplicationIdPresent = Provider.autoDispose<bool>(
  (ref) => ref.watch(
    jobApplicationProvider.select(
      (value) =>
          value.maybeWhen(data: (data) => data.jobEntry.id != null, orElse: () => false),
    ),
  ),
);

final isCompanyIdPresent = Provider.autoDispose<bool>(
  (ref) => ref.watch(
    appliedCompanyFormProvider.select(
      (value) =>
          value.maybeWhen(data: (data) => data.id != null, orElse: () => false),
    ),
  ),
);
