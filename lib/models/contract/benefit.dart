import 'package:equatable/equatable.dart';

class Benefit extends Equatable {
  final int? id;
  final String benefit;
  final int? contractId;

  const Benefit({this.id, required this.benefit, this.contractId});

  Benefit copyWith({int? id, String? benefit}) {
    return Benefit(
      id: id ?? this.id,
      benefit: benefit ?? this.benefit,
      contractId: contractId,
    );
  }

  Benefit.fromJson(Map<String, dynamic> json)
    : id = json[BenefitsTable.id],
      benefit = json[BenefitsTable.benefit],
      contractId = json[BenefitsTable.contractId];

  Map<String, dynamic> toJson() => {
    BenefitsTable.benefit: benefit,
    BenefitsTable.contractId: contractId,
  };

  @override
  String toString() {
    return ''' {Id => $id Benefit => $benefit ContractId => $contractId} ''';
  }

  @override
  List<Object?> get props => [id];
}

class BenefitsTable {
  static String tableName = 'benefits_table';

  static String id = '_benefit_id';
  static String benefit = 'benefit';
  static String contractId = 'contract_id';
}
