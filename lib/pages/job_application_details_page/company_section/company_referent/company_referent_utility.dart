enum RoleType { hr, dev, pm, ceo, cto, ad, other }

extension RoleTypeX on RoleType {
  String get displayName {
    switch (this) {
      case RoleType.hr:
        return 'Risorse Umane';
      case RoleType.dev:
        return 'Sviluppatore';
      case RoleType.pm:
        return 'Project Manager';
      case RoleType.ceo:
        return 'Direttore Generale';
      case RoleType.cto:
        return 'Direttore Tecnico';
      case RoleType.ad:
        return 'Amministratore';
      case RoleType.other:
        return 'Altro';
    }
  }
}

RoleType roleTypeFromString(String value) {
  switch (value) {
    case 'hr':
      return RoleType.hr;
    case 'dev':
      return RoleType.dev;
    case 'pm':
      return RoleType.pm;
    case 'ceo':
      return RoleType.ceo;
    case 'cto':
      return RoleType.cto;
    case 'ad':
      return RoleType.ad;
    case 'other':
      return RoleType.other;
    default:
      return RoleType.other;
  }
}
