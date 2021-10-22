class Role {
  Map<UserRole, String> map = {
    UserRole.ADMIN: 'Administrador',
    UserRole.WAITING_FOR_APPROVAL: 'Aguardando aprovação'
  };

  String getRoleByEnum(UserRole userRole) {
    return map[userRole];
  }

  List getRoles() {
    var list = [];
    map.forEach((key, value) => list.add(value));
    return list;
  }
}

enum UserRole { ADMIN, DEFAULT, WAITING_FOR_APPROVAL }
