import 'enums/equipment_status_enum.dart';

class Equipment {
  int id;

  String description;
  String status;

  int get getId => this.id;
  set setId(int id) => this.id = id;

  String get getDescription => description;
  set setDescription(String description) => this.description = description;

  String get getStatus => status;
  set setStatus(String status) => this.status = status;

  Equipment(this.description, this.status);

  Equipment.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        status = json['status'];

  Map<String, dynamic> toJson() =>
      {'description': description, 'status': status};
}
