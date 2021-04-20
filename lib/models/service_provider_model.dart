class ServiceProvider {
  String _id;
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

  ServiceProvider.fromJson(Map<String, dynamic> json)
      : _name = json['name'] == null ? '(vazio)' : json['name'],
        _category = json['category'] == null ? '(vazio)' : json['category'],
        _phone = json['phone'] == null ? '(vazio)' : json['phone'],
        _email = json['email'] == null ? '(vazio)' : json['email'];

  ServiceProvider();

  String get id => this._id;
  set id(String value) => this._id = value;

  String get name => this._name;
  set name(String value) => this._name = value;

  String get category => this._category;
  set category(String value) => this._category = value;

  String get phone => this._phone;
  set phone(String value) => this._phone = value;

  String get email => this._email;
  set email(String value) => this._email = value;
}
