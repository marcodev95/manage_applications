import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/job_application/job_application_referent.dart';

class CompanyReferentBadge extends StatelessWidget {
  const CompanyReferentBadge(this.referent, {super.key});

  final JobApplicationReferent referent;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: referent.referentAffiliation.color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            referent.referentAffiliation.displayName,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        SizedBox(
          width: 180.0,
          child: Tooltip(
            message: referent.referent.name,
            child: Text(
              referent.referent.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,

              style: TextStyle(fontSize: AppStyle.tableTextFontSize),
            ),
          ),
        ),
      ],
    );
  }
}
