import 'dart:convert';

import 'equipment_model.dart';

class Department {
  String name;
  List<Equipment> equipments;

  Department();

  String get getName => name;
  setName(String name) => this.name = name;

  List get getEquipments => equipments;
  setEquipments(List equipments) => this.equipments = equipments;

  Map<String, dynamic> toJson() => {
        'name': name,
        'equipments': equipments.map((e) => e.toJson()).toList(),
      };
}
