class Unit {
  String _name;
  String _address;
  int _number;
  String _district;

  get name => this._name;
  set name(String name) => this._name = name;

  get address => this._address;
  set address(String address) => this._address = address;

  get number => this._number;
  set number(number) => this._number = number;

  get district => this._district;
  set district(district) => this._district = district;

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
