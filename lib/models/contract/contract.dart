import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/contract/remuneration.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/contract_form/contract_form_utlity.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class Contract {
  final int? id;
  final ContractsType type;
  final String? ccnl;
  final bool isTrialContract;
  final String? notes;

  final String? contractDuration;
  final DateTime? startDate;
  final DateTime? endDate;

  final String workingHour;

  final WorkPlace workPlace;
  final String? workPlaceAddress;

  final Remuneration? remuneration;
  final int? jobApplicationId;

  Contract({
    this.id,
    required this.type,
    required this.workPlace,
    this.ccnl,
    this.isTrialContract = false,
    this.notes,
    this.contractDuration,
    this.startDate,
    this.endDate,
    this.workingHour = '40',
    this.remuneration,
    this.workPlaceAddress,
    this.jobApplicationId,
  });

  Contract.fromJson(Map<String, dynamic> json)
    : id = json[ContractTableColumns.id],
      type = getContractsTypeFromString(json[ContractTableColumns.type]),

      contractDuration = json[ContractTableColumns.contractDuration],
      startDate = parseDateTimeOrNull(json[ContractTableColumns.startDate]),
      endDate = parseDateTimeOrNull(json[ContractTableColumns.endDate]),
      ccnl = json[ContractTableColumns.ccnl],
      isTrialContract = fromIntToBool(
        json[ContractTableColumns.isTrialContract],
      ),
      notes = json[ContractTableColumns.notes],
      workingHour = json[ContractTableColumns.workingHour],

      workPlace = getWorkPlaceFromString(json[ContractTableColumns.workPlace]),
      workPlaceAddress = json[ContractTableColumns.workPlaceAddress],
      remuneration = Remuneration.fromJson(json),
      jobApplicationId = json[ContractTableColumns.jobApplicationId];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};

    json[ContractTableColumns.type] = type.name;
    json[ContractTableColumns.contractDuration] = contractDuration;

    json[ContractTableColumns.ccnl] = ccnl;
    json[ContractTableColumns.isTrialContract] = fromBoolToInt(isTrialContract);
    json[ContractTableColumns.notes] = notes;
    json[ContractTableColumns.workingHour] = workingHour;
    json[ContractTableColumns.workPlace] = workPlace.name;
    json[ContractTableColumns.jobApplicationId] = jobApplicationId;

    json[ContractTableColumns.workPlaceAddress] = workPlaceAddress;

    json[ContractTableColumns.ral] = remuneration?.ral;
    json[ContractTableColumns.monthlyPayments] = remuneration?.monthlyPayments;
    json[ContractTableColumns.salary] = remuneration?.monthlySalary;
    json[ContractTableColumns.isProductionBonusPresent] = fromBoolToInt(
      remuneration!.isProductionBonusPresent,
    );
    json[ContractTableColumns.isOvertimePresent] = fromBoolToInt(
      remuneration!.isOvertimePresent,
    );

    if (startDate != null) {
      json[ContractTableColumns.startDate] = dbFormat.format(startDate!);
    }

    if (endDate != null) {
      json[ContractTableColumns.endDate] = dbFormat.format(endDate!);
    }

    return json;
  }

  Contract copyWith({
    int? id,
    ContractsType? type,
    int? ral,
    int? salary,
    String? contractDuration,
    DateTime? startDate,
    DateTime? endDate,
    String? ccnl,
    bool? isTrialContract,
    String? notes,
    String? workingHour,
    WorkPlace? workPlace,
    String? workPlaceAddress,
    Remuneration? remuneration,
  }) {
    return Contract(
      id: id ?? this.id,
      type: type ?? this.type,
      workPlace: workPlace ?? this.workPlace,
      workPlaceAddress: workPlaceAddress ?? this.workPlaceAddress,
      remuneration: remuneration ?? this.remuneration,
      contractDuration: contractDuration ?? this.contractDuration,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      ccnl: ccnl ?? this.ccnl,
      isTrialContract: isTrialContract ?? this.isTrialContract,
      notes: notes ?? this.notes,
      workingHour: workingHour ?? this.workingHour,
      jobApplicationId: jobApplicationId,
    );
  }

  static Contract initialValue() {
    return Contract(
      type: ContractsType.definire,
      contractDuration: '',
      workPlace: WorkPlace.remoto,
    );
  }

  @override
  String toString() {
    return '''
      ${ContractTableColumns.id} => $id
      ${ContractTableColumns.type} => $type
      ${ContractTableColumns.isTrialContract} => $isTrialContract
      ${ContractTableColumns.workPlaceAddress} => $workPlaceAddress
      ${ContractTableColumns.contractDuration} => $contractDuration
      ${ContractTableColumns.startDate} => $startDate
      ${ContractTableColumns.endDate} => $endDate
      ${ContractTableColumns.jobApplicationId} => $jobApplicationId
      ${ContractTableColumns.workPlace} => $workPlace
      Remuneration: $remuneration
    ''';
  }

  @override
  bool operator ==(other) => other is Contract && other.id == id;

  @override
  int get hashCode => id!;
}

const String contractTable = "contract_table";

class ContractTableColumns {
  static String id = "_id_contract";
  static String type = "type";
  static String ral = "ral";
  static String salary = "salary";
  static String monthlyPayments = 'monthly_payments';
  static String contractDuration = "contract_duration";
  static String startDate = "start_date";
  static String endDate = "end_date";
  static String ccnl = 'ccnl';
  static String isTrialContract = 'is_trial_contract';
  static String notes = 'notes';
  static String workingHour = 'working_hours';
  static String isOvertimePresent = 'is_overtime_resent';
  static String isProductionBonusPresent = 'is_production_bonus_present';
  static String workPlace = 'work_place';
  static String workPlaceAddress = 'work_place_address';
  static String jobApplicationId = "fk_job_application_id";
}

class ContractUI extends Equatable {
  final int? id;
  final ContractsType type;
  final String? contractDuration;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isTrialContract;
  final String? workPlaceAddress;
  final int? ral;

  final int? jobApplicationId;

  const ContractUI({
    this.id,
    required this.type,
    this.contractDuration,
    this.startDate,
    this.endDate,
    this.isTrialContract = false,
    this.workPlaceAddress,
    this.ral,
    this.jobApplicationId,
  });

  ContractUI.fromJson(Map<String, dynamic> json)
    : id = json[ContractTableColumns.id],
      type = getContractsTypeFromString(json[ContractTableColumns.type]),
      contractDuration = json[ContractTableColumns.contractDuration],
      startDate = parseDateTimeOrNull(json[ContractTableColumns.startDate]),
      endDate = parseDateTimeOrNull(json[ContractTableColumns.endDate]),
      isTrialContract = fromIntToBool(
        json[ContractTableColumns.isTrialContract],
      ),
      workPlaceAddress = json[ContractTableColumns.workPlaceAddress],
      ral = json[ContractTableColumns.ral],
      jobApplicationId = json[ContractTableColumns.jobApplicationId];

  ContractUI copyWith({
    int? id,
    ContractsType? type,
    String? contractDuration,
    DateTime? startDate,
    DateTime? endDate,
    int? ral,
    String? workPlaceAddress,
    bool? isTrialContract,
    int? jobApplicationId,
  }) {
    return ContractUI(
      id: id ?? this.id,
      type: type ?? this.type,
      contractDuration: contractDuration ?? this.contractDuration,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isTrialContract: isTrialContract ?? this.isTrialContract,
      workPlaceAddress: workPlaceAddress ?? this.workPlaceAddress,
      ral: ral ?? this.ral,
      jobApplicationId: jobApplicationId ?? this.jobApplicationId,
    );
  }

  @override
  String toString() {
    return '''
      ${ContractTableColumns.id} => $id
      ${ContractTableColumns.type} => $type
      ${ContractTableColumns.isTrialContract} => $isTrialContract
      ${ContractTableColumns.workPlaceAddress} => $workPlaceAddress
      ${ContractTableColumns.ral} => $ral
      ${ContractTableColumns.contractDuration} => $contractDuration
      ${ContractTableColumns.startDate} => $startDate
      ${ContractTableColumns.endDate} => $endDate
    ''';
  }

  @override
  List<Object?> get props => [id];
}

extension ContractUIX on ContractUI {
  String get trialContractLabel => isTrialContract ? 'Si' : 'No';
}

extension ContractX on Contract {
  ContractUI toUI({int? ral, int? jobApplicationId}) {
    return ContractUI(
      id: id,
      type: type,
      contractDuration: contractDuration,
      startDate: startDate,
      endDate: endDate,
      isTrialContract: isTrialContract,
      ral: ral,
      workPlaceAddress: workPlaceAddress,
      jobApplicationId: jobApplicationId,
    );
  }
}
