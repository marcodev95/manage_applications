import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/job_application/job_application_referents.dart';

class Company extends Equatable {
  final int? id;
  final String name;
  final String city;
  final String address;
  final String? phoneNumber;
  final String website;
  final String? workingHours;
  final String email;

  const Company({
    this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.website,
    this.phoneNumber,
    this.workingHours,
    required this.email,
  });

  Company copyWith({
    int? id,
    String? name,
    String? city,
    String? address,
    String? phoneNumber,
    String? website,
    String? workingHours,
    String? email,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      workingHours: workingHours ?? this.workingHours,
      email: email ?? this.email,
    );
  }

  Company.fromJson(Map<String, dynamic> json)
    : id = json[CompanyTableColumns.id],
      name = json[CompanyTableColumns.name],
      city = json[CompanyTableColumns.city],
      address = json[CompanyTableColumns.address] ?? '',
      phoneNumber = json[CompanyTableColumns.phoneNumber] ?? '',
      website = json[CompanyTableColumns.website],
      workingHours = json[CompanyTableColumns.workingHours],
      email = json[CompanyTableColumns.email];

  Map<String, dynamic> toJson() => {
    CompanyTableColumns.name: name,
    CompanyTableColumns.city: city,
    CompanyTableColumns.address: address,
    CompanyTableColumns.phoneNumber: phoneNumber,
    CompanyTableColumns.website: website,
    CompanyTableColumns.workingHours: workingHours,
    CompanyTableColumns.email: email,
  };

  static Company defaultValue() {
    return const Company(
      name: "",
      city: "",
      address: "",
      website: "",
      email: '',
    );
  }

  @override
  String toString() {
    return ''' {
      Id => $id
      Name => $name
      Cità => $city
      Address => $address
      Phone_Number => $phoneNumber
      Website => $website
      WorkingHours => $workingHours
      Email => $email
    } ''';
  }

  @override
  List<Object?> get props => [id, name, city, address, website];
}

const String companyTable = "company_table";

class CompanyTableColumns {
  static String id = "_id_company";
  static String name = "name";
  static String city = "city";
  static String address = "address";
  static String phoneNumber = "phone_number";
  static String website = "website";
  static String workingHours = "working_hours";
  static String email = "email";
}

const String clientCompanyTable = "client_company_table";

class FinalCompanyTableColumns {
  static String id = "_id_final_company_table";
  static String clientCompanyId = "client_company_id";
  static String jobAppId = "fk_job_app_id";
  static String companyId = "fk_company_id";
}

extension CompanyX on Company {
  String get displayAddress {
    return '$address, $city';
  }

  CompanyRef get asRef {
    return CompanyRef(id: id!, name: name);
  }

  CompanyOption _buildCompanyOption(ReferentAffiliation type) {
    return CompanyOption(CompanyRef(id: id!, name: name), type);
  }

  CompanyOption get asMain {
    return _buildCompanyOption(ReferentAffiliation.main);
  }

  CompanyOption get asClient {
    return _buildCompanyOption(ReferentAffiliation.client);
  }
}

class CompanyRef extends Equatable {
  final int id;
  final String name;

  const CompanyRef({required this.id, required this.name});

  CompanyRef.fromJson(Map<String, dynamic> json)
    : id = json[CompanyTableColumns.id],
      name = json[CompanyTableColumns.name];

  static CompanyRef initialValue() {
    return CompanyRef(id: -1, name: 'N/A');
  }

  @override
  String toString() {
    return ''' { ID => $id - Name => $name } ''';
  }

  @override
  List<Object?> get props => [id];
}
