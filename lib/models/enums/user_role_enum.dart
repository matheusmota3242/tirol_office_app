class Role {
  Map<UserRole, String> map = {
    UserRole.ADMIN: 'admin',
    UserRole.DEFAULT: 'default',
    UserRole.WAITING_FOR_APPROVAL: 'waiting'
  };

  String getRoleByEnum(UserRole userRole) {
    return map[userRole];
  }
}

enum UserRole { ADMIN, DEFAULT, WAITING_FOR_APPROVAL }

Map<UserRole, String> map = {
  UserRole.ADMIN: 'admin',
  UserRole.DEFAULT: 'default',
  UserRole.WAITING_FOR_APPROVAL: 'waiting'
};
