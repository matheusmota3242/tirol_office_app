import 'equipment_model.dart';

class Department {
  String _id;
  String _name;
  String _unitName;
  List<Equipment> _equipments;

  Department() {
    _equipments = <Equipment>[];
  }

  String get id => this._id;
  set id(String value) => this._id = value;

  String get name => _name;
  set name(String name) => this._name = name;

  String get unitName => this._unitName;
  set unitName(String value) => this._unitName = value;

  List get equipments => _equipments;
  set equipments(List equipments) => this._equipments = equipments;

  Department.fromJson(Map<String, dynamic> data)
      : _name = data['name'],
        _equipments = List<Equipment>.from(data['equipments']
            .map((equipment) => Equipment.fromJson(equipment))),
        _unitName = data['unitName'];

  Map<String, dynamic> toJson() => {
        'name': _name,
        'equipments': _equipments.map((e) => e.toJson()).toList(),
        'unitName': unitName,
      };
}
