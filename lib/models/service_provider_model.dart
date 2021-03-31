class ServiceProvider {
  String _name;
  String _category;
  String _phone;
  String _email;

  Map<String, dynamic> toJson() => {
        'name': _name,
        'category': _category,
        'phone': _phone,
        'email': _email,
      };

  String get name => this._name;
  set name(String value) => this._name = value;

  String get category => this._category;
  set category(String value) => this._category = value;

  String get phone => this._phone;
  set phone(String value) => this._phone = value;

  String get email => this._email;
  set email(String value) => this._email = value;
}
