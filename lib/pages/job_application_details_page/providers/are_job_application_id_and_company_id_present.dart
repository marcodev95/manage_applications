import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/application_company_details_page/applied_company_section/applied_company_form_controller.dart';
import 'package:manage_applications/pages/job_application_details_page/job_data_section/job_data_provider.dart';

final areJobApplicationIdAndCompanyIdPresent = Provider.autoDispose<bool>(
  (ref) =>
      ref.watch(isJobApplicationIdPresent) && ref.watch(isCompanyIdPresent),
);

final isJobApplicationIdPresent = Provider.autoDispose<bool>(
  (ref) => ref.watch(
    jobDataProvider.select(
      (value) =>
          value.maybeWhen(data: (data) => data.id != null, orElse: () => false),
    ),
  ),
);

final isCompanyIdPresent = Provider.autoDispose<bool>(
  (ref) => ref.watch(
    appliedCompanyFormController.select(
      (value) =>
          value.maybeWhen(data: (data) => data.id != null, orElse: () => false),
    ),
  ),
);



 /* jobApplicationDetailsProvider.select(
      (value) => value.company.id != null && value.jobData.id != null,
    ), */