import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';

class CompanyOption extends Equatable {
  final CompanyRef companyRef;
  final ReferentAffiliation companyType;

  const CompanyOption(this.companyRef, this.companyType);

  @override
  List<Object?> get props => [companyRef];
}
