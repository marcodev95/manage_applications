import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/interview/referent_with_affiliation.dart';
import 'package:manage_applications/models/job_application/job_application_referent.dart';

class CompanyReferentBadge extends StatelessWidget {
  const CompanyReferentBadge(this.referentWithAffiliation, {super.key});

  final ReferentWithAffiliation referentWithAffiliation;

  @override
  Widget build(BuildContext context) {
    final referent = referentWithAffiliation.referent;
    final affiliation = referentWithAffiliation.affiliation;
    return Row(
      spacing: 8.0,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: affiliation.color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            affiliation.displayName,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        SizedBox(
          width: 180.0,
          child: Tooltip(
            message: referent.name,
            child: Text(
              referent.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: AppStyle.tableTextFontSize),
            ),
          ),
        ),
      ],
    );
  }
}
