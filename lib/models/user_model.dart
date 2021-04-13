import 'enums/user_role_enum.dart';

class User {
  String _id;
  String _name;
  String _role;
  bool _status;
  String _email;
  String _password;

  Map<String, dynamic> toJson() => {
        'name': name,
        'role': role,
      };

  String get id => _id;
  set id(String id) => this._id = id;

  String get name => _name;
  set name(String name) => this._name = name;

  String get role => _role;
  set role(String role) => this._role = role;

  String get email => email;
  set email(String email) => this._email = email;

  String get password => password;
  set password(String password) => this._password = password;
}
