import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_utility.dart';

class Referent {
  final int? id;
  final String name;
  final String? phoneNumber;
  final String email;
  final RoleType role;
  final int? companyId;

  const Referent({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.companyId,
  });

  Referent.fromJson(Map<String, dynamic> json)
    : id = json[ReferentTableColumns.id],
      name = json[ReferentTableColumns.name],
      role = roleTypeFromString(json[ReferentTableColumns.role]),
      email = json[ReferentTableColumns.email],
      phoneNumber = json[ReferentTableColumns.phoneNumber],
      companyId = json[ReferentTableColumns.companyId];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json[ReferentTableColumns.name] = name;
    json[ReferentTableColumns.phoneNumber] = phoneNumber;
    json[ReferentTableColumns.email] = email;
    json[ReferentTableColumns.role] = role.name;
    json[ReferentTableColumns.companyId] = companyId;

    return json;
  }

  Referent copyWith({int? id}) {
    return Referent(id: id, name: name, email: email, role: role);
  }

  @override
  String toString() {
    return '''
      Id => $id 
      Name => $name
      Phone => $phoneNumber
      Email => $email
      Role => $role
      FkCompanyId => $companyId     
    ''';
  }
}

class ReferentDetails {
  final JobApplicationReferent jobApplicationReferent;
  final CompanyOption company;

  const ReferentDetails({
    required this.jobApplicationReferent,
    required this.company,
  });

  ReferentDetails.fromJson(Map<String, dynamic> json)
    : jobApplicationReferent = JobApplicationReferent.fromJson(json),
      company = CompanyOption(
        CompanyRef(id: json['company_id'], name: json['company_name']),
        fromStringToReferentAffiliation(
          json[JobApplicationReferentsColumns.referentAffiliation],
        ),
      );

  static Referent toDB(ReferentDetails details) {
    return Referent(
      id: details.jobApplicationReferent.referent.id,
      name: details.jobApplicationReferent.referent.name,
      role: details.jobApplicationReferent.referent.role,
      email: details.jobApplicationReferent.referent.email,
      phoneNumber: details.jobApplicationReferent.referent.phoneNumber,
      companyId: details.company.companyRef.id,
    );
  }

  @override
  String toString() {
    return ''' 
      {
        jobApplicationReferent: $jobApplicationReferent
        Company: $company
      }
    ''';
  }
}

const referentTableName = "referent_table";

class ReferentTableColumns {
  static String id = "_id_referent";
  static String name = "name";
  static String phoneNumber = "phone_number";
  static String email = "email";
  static String role = "role";
  static String companyId = "fk_company_id";
}

class CompanyOption extends Equatable {
  final CompanyRef companyRef;
  final ReferentAffiliation companyType;

  const CompanyOption(this.companyRef, this.companyType);

  @override
  List<Object?> get props => [companyRef];
}

class ReferentWithCompany {
  final Referent referent;
  final CompanyRef company;

  ReferentWithCompany({required this.referent, required this.company});

  factory ReferentWithCompany.fromJson(Map<String, dynamic> json) {
    return ReferentWithCompany(
      referent: Referent.fromJson(json),
      company: CompanyRef(
        id: json[CompanyTableColumns.id],
        name: json['c_name'],
      ),
    );
  }
}