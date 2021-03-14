import 'dart:convert';

import 'equipment_model.dart';

class Department {
  String _name;
  List<Equipment> _equipments;
  bool _needsAttention;

  Department() {
    _needsAttention = false;
  }

  String get name => _name;
  setName(String name) => this._name = name;

  List get equipments => _equipments;
  set equipments(List equipments) => this._equipments = equipments;

  bool get needsAttention => this._needsAttention;
  set needsAttention(bool needsAttention) =>
      this._needsAttention = needsAttention;

  Department.fromJson(Map<String, dynamic> data)
      : _name = data['name'],
        _equipments = List<Equipment>.from(data['equipments']
            .map((equipment) => Equipment.fromJson(equipment))),
        _needsAttention = data['needsAttention'];

  Map<String, dynamic> toJson() => {
        'name': _name,
        'equipments': _equipments.map((e) => e.toJson()).toList(),
        'needsAttention': _needsAttention
      };
}
