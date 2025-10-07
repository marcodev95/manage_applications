import 'package:manage_applications/models/job_application/job_application_referent.dart';
import 'package:manage_applications/models/referent/referent.dart';

class ReferentWithAffiliation {
  final Referent referent;
  final ReferentAffiliation affiliation;

  ReferentWithAffiliation({required this.referent, required this.affiliation});

  factory ReferentWithAffiliation.fromJson(Map<String, dynamic> json) {
    final referent = {
      ReferentTableColumns.id: json[ReferentTableColumns.id],
      ReferentTableColumns.name: json[ReferentTableColumns.name],
      ReferentTableColumns.email: json[ReferentTableColumns.email],
      ReferentTableColumns.role: json[ReferentTableColumns.role],
    };

    return ReferentWithAffiliation(
      referent: Referent.fromJson(referent),
      affiliation: fromStringToReferentAffiliation(
        json[JobApplicationReferentsColumns.referentAffiliation],
      ),
    );
  }

  ReferentWithAffiliation copyWith({
    Referent? referent,
    ReferentAffiliation? affiliation,
  }) {
    return ReferentWithAffiliation(
      referent: referent ?? this.referent,
      affiliation: affiliation ?? this.affiliation,
    );
  }
}
