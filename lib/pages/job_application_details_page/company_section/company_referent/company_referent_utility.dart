enum RoleType { hr, dev, pm, ceo, cto, ad, altro }

extension RoleTypeX on RoleType {
  String get displaName {
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
      case RoleType.altro:
        return 'Altro';
    }
  }
}

RoleType roleTypeFromString(String value) {
  switch (value) {
    case 'Risorse Umane':
      return RoleType.hr;
    case 'Sviluppatore':
      return RoleType.dev;
    case 'Project Manager':
      return RoleType.pm;
    case 'Direttore Generale':
      return RoleType.ceo;
    case 'Direttore Tecnico':
      return RoleType.cto;
    case 'Amministratore':
      return RoleType.ad;
    case 'Altro':
      return RoleType.altro;
    default:
      return RoleType.altro;
  }
}
