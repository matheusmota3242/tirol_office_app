import 'equipment_model.dart';
import 'special_equipment_model.dart';

class Department {
  String _id;

  String _name;
  List<Equipment> _equipments;
  bool _needsAttention;

  Department() {
    _needsAttention = false;
    _equipments = <Equipment>[];
  }

  String get id => this._id;
  set id(String value) => this._id = value;

  String get name => _name;
  set name(String name) => this._name = name;

  List get equipments => _equipments;
  set equipments(List equipments) => this._equipments = equipments;

  bool get needsAttention => this._needsAttention;
  set needsAttention(bool needsAttention) =>
      this._needsAttention = needsAttention;

  Department.fromJson(Map<String, dynamic> data)
      : _name = data['name'],
        _equipments = List<Equipment>.from(data['equipments'].map((equipment) =>
            equipment['interval'] != null
                ? SpecialEquipment.fromJson(equipment)
                : Equipment.fromJson(equipment))),
        _needsAttention = data['needsAttention'];

  Map<String, dynamic> toJson() => {
        'name': _name,
        'equipments': _equipments.map((e) => e.toJson()).toList(),
        'needsAttention': _needsAttention
      };
}
