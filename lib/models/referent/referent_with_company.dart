import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/referent/referent.dart';

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
