import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class Remuneration extends Equatable {
  final int? ral;
  final double? monthlySalary;
  final int? monthlyPayments;
  final bool isProductionBonusPresent;
  final bool isOvertimePresent;

  const Remuneration({
    this.ral,
    this.monthlySalary,
    this.monthlyPayments,
    this.isProductionBonusPresent = false,
    this.isOvertimePresent = false,
  });

  Remuneration.fromJson(Map<String, dynamic> json)
    : ral = json[ContractTableColumns.ral],
      monthlySalary = json[ContractTableColumns.salary],
      monthlyPayments = json[ContractTableColumns.monthlyPayments],
      isProductionBonusPresent = fromIntToBool(
        json[ContractTableColumns.isProductionBonusPresent],
      ),
      isOvertimePresent = fromIntToBool(
        json[ContractTableColumns.isOvertimePresent],
      );

  @override
  String toString() {
    return ''' 
    {
      ral: $ral
      monthlyPayments: $monthlyPayments
      monthlySalary: $monthlySalary
      isProductionBonusPresent: $isProductionBonusPresent
      isOvertimePresent: $isOvertimePresent
    } ''';
  }

  @override
  List<Object?> get props => [];
}
