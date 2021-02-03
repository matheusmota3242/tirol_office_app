import 'equipment_model.dart';

class ChecklistItem {
  String description;
  bool status;
  String impediment;
  Equipment equipment;

  ChecklistItem(this.description, this.status,
      {this.impediment, this.equipment});

  String get getDescription => description;
  set setDescription(String description) => this.description = description;

  bool get getStatus => status;
  set setStatus(bool status) => this.status = status;

  String get getImpediment => impediment;
  set setImpediment(String impediment) => this.impediment = impediment;
}
