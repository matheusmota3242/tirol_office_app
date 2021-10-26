class Unit {
  String _id;
  String _name;
  String _address;
  String _number;
  String _district;

  String get id => this._id;
  set id(String value) => this._id = value;

  String get name => this._name;
  set name(String name) => this._name = name;

  String get address => this._address;
  set address(String address) => this._address = address;

  String get number => this._number;
  set number(String number) => this._number = number;

  String get district => this._district;
  set district(String district) => this._district = district;

  Unit();

  Map<String, dynamic> toJson() => {
        'name': _name,
        'address': _address,
        'number': _number,
        'district': _district,
      };

  Unit.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _address = json['address'],
        _number = json['number'],
        _district = json['district'];
}
