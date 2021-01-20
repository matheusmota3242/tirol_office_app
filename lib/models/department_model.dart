import 'equipment_model.dart';

class Department {
  String name;
  List<Equipment> equipments;

  Department(this.name, this.equipments);

  String get getName => name;
  set setName(String name) => this.name = name;

  List get getEquipments => equipments;
  set setEquipments(List equipments) => this.equipments = equipments;
}
