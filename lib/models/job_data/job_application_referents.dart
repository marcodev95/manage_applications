import 'package:manage_applications/widgets/components/utility.dart';

class JobApplicationReferent {
  final int jobApplicationId;
  final int companyReferentId;
  final bool involvedInInterview;

  JobApplicationReferent({
    required this.jobApplicationId,
    required this.companyReferentId,
    this.involvedInInterview = true,
  });

  Map<String, dynamic> toMap() {
    return {
      JobApplicationReferentsColumns.jobApplicationId: jobApplicationId,
      JobApplicationReferentsColumns.referentId: companyReferentId,
      JobApplicationReferentsColumns.involvedInInterview: fromBoolToInt(
        involvedInInterview,
      ),
    };
  }

  factory JobApplicationReferent.fromMap(Map<String, dynamic> map) {
    return JobApplicationReferent(
      jobApplicationId: map[JobApplicationReferentsColumns.jobApplicationId] as int,
      companyReferentId: map[JobApplicationReferentsColumns.referentId] as int,
      involvedInInterview: fromIntToBool(
        map[JobApplicationReferentsColumns.involvedInInterview],
      ),
    );
  }
}

class JobApplicationReferentsColumns {
  static const tableName = 'job_application_referents';

  static const jobApplicationId = 'job_application_id';
  static const referentId = 'referent_id';
  static const involvedInInterview = 'involved_in_interview';
}
