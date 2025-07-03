import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/errors/ui_message.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/widget/company_form_widget.dart';
import 'package:manage_applications/providers/companies_paginator_notifier.dart';
import 'package:manage_applications/providers/job_applications_paginator_notifier.dart';
import 'package:manage_applications/repository/company_repository.dart';

class CompanyDetailsForm extends ConsumerStatefulWidget {
  const CompanyDetailsForm(this.details, {super.key});

  final Company details;

  @override
  ConsumerState<CompanyDetailsForm> createState() => _CompanyDetailsFormState();
}

class _CompanyDetailsFormState extends ConsumerState<CompanyDetailsForm> {
  @override
  Widget build(BuildContext context) {
    return CompanyFormWidget(
      company: widget.details,
      submit: (c, f) async {
        if (f.currentState!.validate()) {
          final result = await updateCompany(c);

          if (!context.mounted) return;

          result.handleResult(context: context, ref: ref);
        }
      },
    );
  }

  Future<OperationResult> updateCompany(Company c) async {
    try {
      final repository = ref.read(companyRepositoryProvider);
      await repository.updateCompany(c);

      await ref.read(companiesPaginatorProvider.notifier).reloadCurrentPage();

      final bool isCompanyNameChange =
          widget.details.name.trim() != c.name.trim();

      if (isCompanyNameChange) {
        ref
            .read(paginatorApplicationsUIProvider.notifier)
            .updateCompanyNameForCompany(
              CompanyRef(id: widget.details.id!, name: c.name),
            );
      }

      return Success<bool>(data: true, message: SuccessMessage.saveMessage);
    } catch (e, stackTrace) {
      return mapToFailure(e, stackTrace);
    }
  }
}
