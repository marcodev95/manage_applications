enum ContractsType {
  definire,
  stage,
  apprendistato,
  determinato,
  indeterminato,
}

extension ContractsTypeExtension on ContractsType {
  String get displayName {
    switch (this) {
      case ContractsType.definire:
        return 'Da definire';
      case ContractsType.stage:
        return 'Stage';
      case ContractsType.apprendistato:
        return 'Apprendistato';
      case ContractsType.determinato:
        return 'Determinato';
      case ContractsType.indeterminato:
        return 'Indeterminato';
    }
  }
}

ContractsType getContractsTypeFromString(String value) {
  switch (value) {
    case 'definire':
      return ContractsType.definire;
    case 'stage':
      return ContractsType.stage;
    case 'apprendistato':
      return ContractsType.apprendistato;
    case 'determinato':
      return ContractsType.determinato;
    case 'indeterminato':
      return ContractsType.indeterminato;
    default:
      return ContractsType.definire;
  }
}

enum WorkPlace { remoto, azienda, cliente, altro }

extension WorkPlaceExtension on WorkPlace {
  String get displayName {
    switch (this) {
      case WorkPlace.remoto:
        return 'Remoto';
      case WorkPlace.azienda:
        return 'Azienda';
      case WorkPlace.altro:
        return 'Altro';
      case WorkPlace.cliente:
        return 'Cliente';
    }
  }
}

WorkPlace getWorkPlaceFromString(String value) {
  switch (value) {
    case 'remoto':
      return WorkPlace.remoto;
    case 'azienda':
      return WorkPlace.azienda;
    case 'altro':
      return WorkPlace.altro;
    case 'cliente':
      return WorkPlace.cliente;
    default:
      return WorkPlace.azienda;
  }
}
