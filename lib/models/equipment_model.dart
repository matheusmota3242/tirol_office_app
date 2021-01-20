import 'enums/equipment_status_enum.dart';

class Equipment {
  String name;
  EquipmentStatus equipmentStatus;

  String get getName => name;
  set setName(String name) => this.name = name;

  Equipment(this.name, this.equipmentStatus);
}
