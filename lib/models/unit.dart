class Unit {
  String _name;

  get name => this._name;
  set name(String name) => this._name = name;

  Unit();

  Map<String, dynamic> toJson() => {
        'name': _name,
      };

  Unit.fromJson(Map<String, dynamic> json) : _name = json['name'];
}
