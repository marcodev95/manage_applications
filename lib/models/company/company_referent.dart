import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/pages/job_application_details_page/company_section/company_referent/company_referent_utility.dart';

class CompanyReferent {
  final int? id;
  final String name;
  final String? phoneNumber;
  final String email;
  final RoleType role;
  final int? jobDataId;
  final int? companyId;
  final CompanyType companyType;

  const CompanyReferent({
    this.id,
    required this.name,
    this.phoneNumber,
    required this.email,
    required this.role,
    this.jobDataId,
    this.companyId,
    required this.companyType,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json[CompanyReferentTableColumns.name] = name;
    json[CompanyReferentTableColumns.phoneNumber] = phoneNumber;
    json[CompanyReferentTableColumns.email] = email;
    json[CompanyReferentTableColumns.role] = role.name;
    //json[CompanyReferentTableColumns.jobDataId] = jobDataId;
    json[CompanyReferentTableColumns.companyId] = companyId;
    json[CompanyReferentTableColumns.companyType] = companyType.name;

    return json;
  }

  @override
  String toString() {
    return '''
      Id => $id 
      Name => $name
      Phone => $phoneNumber
      Email => $email
      Role => $role
      CompanyType => $companyType
      FkJobId => $jobDataId
      FkCompanyId => $companyId     
    ''';
  }
}

class CompanyReferentDetails {
  final int? id;
  final String name;
  final String? phoneNumber;
  final String email;
  final RoleType role;
  final CompanyOption company;

  const CompanyReferentDetails({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.company,
    this.phoneNumber,
  });

  CompanyReferentDetails.fromJson(Map<String, dynamic> json)
    : id = json[CompanyReferentTableColumns.id],
      name = json[CompanyReferentTableColumns.name],
      phoneNumber = json[CompanyReferentTableColumns.phoneNumber] ?? '',
      email = json[CompanyReferentTableColumns.email],
      role = roleTypeFromString(json[CompanyReferentTableColumns.role]),
      company = CompanyOption(
        CompanyRef(id: json['company_id'], name: json['company_name']),
        fromStringToCompanyType(json[CompanyReferentTableColumns.companyType]),
      );

  static CompanyReferent toDB(
    CompanyReferentDetails referent,
    int? applicationId,
  ) {
    return CompanyReferent(
      id: referent.id,
      name: referent.name,
      role: referent.role,
      email: referent.email,
      phoneNumber: referent.phoneNumber,
      companyType: referent.company.companyType,
      companyId: referent.company.companyRef.id,
      //jobDataId: applicationId,
    );
  }

  static CompanyReferentUi toUI(CompanyReferentDetails referent) {
    return CompanyReferentUi(
      id: referent.id,
      name: referent.name,
      role: referent.role,
      email: referent.email,
      companyType: referent.company.companyType,
    );
  }

  CompanyReferentDetails copyWith({int? id}) {
    return CompanyReferentDetails(
      id: id ?? this.id,
      name: name,
      email: email,
      role: role,
      company: company,
    );
  }
}

const companyReferentTableName = "company_referent_table";

class CompanyReferentTableColumns {
  static String id = "_id_company_referent";
  static String name = "name";
  static String phoneNumber = "phone_number";
  static String email = "email";
  static String role = "role";
  static String companyType = "company_type";
  static String jobDataId = "fk_job_data_id";
  static String companyId = "fk_company_id";
}

class CompanyReferentUi extends Equatable {
  final int? id;
  final String name;
  final String email;
  final RoleType role;
  final CompanyType companyType;

  const CompanyReferentUi({
    this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.companyType,
  });

  CompanyReferentUi.fromJson(Map<String, dynamic> json)
    : id = json[CompanyReferentTableColumns.id],
      name = json[CompanyReferentTableColumns.name],
      email = json[CompanyReferentTableColumns.email],
      companyType = fromStringToCompanyType(json[CompanyReferentTableColumns.companyType]),
      role = roleTypeFromString(json[CompanyReferentTableColumns.role]);

  CompanyReferentUi copyWith({
    int? id,
    String? name,
    RoleType? role,
    String? email,
    CompanyType? companyType,
  }) {
    return CompanyReferentUi(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      companyType: companyType ?? this.companyType,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return '''
      Id => $id 
      Name => $name
      Email => $email
      Role => $role    
    ''';
  }
}

class CompanyOption extends Equatable {
  final CompanyRef companyRef;
  final CompanyType companyType;

  const CompanyOption(this.companyRef, this.companyType);

  @override
  List<Object?> get props => [companyRef];
}

enum CompanyType { main, client }

extension CompanyTypeX on CompanyType {
  Color get color {
    return switch (this) {
      CompanyType.main => Colors.blue,
      CompanyType.client => Colors.green,
    };
  }

  String get displayName {
    return switch (this) {
      CompanyType.main => 'P',
      CompanyType.client => 'C',
    };
  }

  bool get isMain => this == CompanyType.main;
}

CompanyType fromStringToCompanyType(String value) {
  switch (value) {
    case 'main':
      return CompanyType.main;
    case 'client':
      return CompanyType.client;
    default:
      return CompanyType.main;
  }
}
