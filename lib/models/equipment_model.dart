import 'enums/equipment_status_enum.dart';

class Equipment {
  String description;
  String status;

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
