class Requirement {
  final int? id;
  final String requirement;
  final int? jobApplicationId;

  Requirement({this.id, required this.requirement, this.jobApplicationId});

  Requirement.fromJson(Map<String, dynamic> json)
    : id = json[RequirementTableColumns.id],
      requirement = json[RequirementTableColumns.requirement],
      jobApplicationId = json[RequirementTableColumns.jobApplicationId];

  Requirement copyWith({int? id, String? requirement}) {
    return Requirement(
      id: id ?? this.id,
      requirement: requirement ?? this.requirement,
      jobApplicationId: jobApplicationId,
    );
  }

  Map<String, dynamic> toJson() => {
    RequirementTableColumns.requirement: requirement,
    RequirementTableColumns.jobApplicationId: jobApplicationId,
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

const String requirementsTable = "requirements_table";

class RequirementTableColumns {
  static String id = "_id_requirement";
  static String requirement = "requirement";
  static String jobApplicationId = "fk_job_application_id";
}
