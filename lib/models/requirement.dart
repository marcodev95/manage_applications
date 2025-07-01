class Requirement {
  final int? id;
  final String requirement;
  final int? jobDataId;

  Requirement({this.id, required this.requirement, this.jobDataId});

  Requirement.fromJson(Map<String, dynamic> json)
      : id = json[RequirementTableColumns.id],
        requirement = json[RequirementTableColumns.requirement],
        jobDataId = json[RequirementTableColumns.jobDataId];

  Requirement copyWith({int? id, String? requirement}) {
    return Requirement(
      id: id ?? this.id,
      requirement: requirement ?? this.requirement,
      jobDataId: jobDataId
    );
  }

  Map<String, dynamic> toJson() => {
        RequirementTableColumns.requirement: requirement,
        RequirementTableColumns.jobDataId: jobDataId,
      };

  static Requirement reset() {
    return Requirement(requirement: "");
  }

  @override
  String toString() {
    return '''
      id: $id
      Requirement: $requirement
    ''';
  }

  @override
  bool operator ==(other) => other is Requirement && other.id == id;

  @override
  int get hashCode => id!;
}

const String requirementTable = "requirement_table";

class RequirementTableColumns {
  static String id = "_id_requirement";
  static String requirement = "requirement";
  static String jobDataId = "fk_job_data_id";
}
