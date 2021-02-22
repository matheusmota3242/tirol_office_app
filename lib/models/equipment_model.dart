import 'enums/equipment_status_enum.dart';

class Equipment {
  String description;
  EquipmentStatus status;

  String get getDescription => description;
  set setDescription(String description) => this.description = description;

  EquipmentStatus get getStatus => status;
  set setStatus(EquipmentStatus status) => this.status = status;

  Equipment(this.description, this.status);
}
