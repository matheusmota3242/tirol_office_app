import 'enums/user_role_enum.dart';

class User {
  String name;
  UserRole role;
  bool status;
  String email;
  String password;

  User(this.name, this.role, this.email, this.password);

  String get getName => name;
  set setName(String name) => this.name = name;

  String get getEmail => email;
  set setEmail(String email) => this.email = email;

  String get getPassword => password;
  set setPassword(String password) => this.password = password;
}
