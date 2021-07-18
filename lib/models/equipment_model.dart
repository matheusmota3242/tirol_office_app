import 'package:tirol_office_app/helpers/equipment_helper.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';

import 'enums/equipment_status_enum.dart';

class Equipment {
  int _id;
  String _description;
  String _status;
  List<Maintenance> _correctiveMaintenances;

  int get id => this._id;
  set id(int id) => this._id = id;

  String get description => _description;
  set description(String description) => this._description = description;

  String get status => _status;
  set status(String status) => this._status = status;

  List<Maintenance> get correctiveMaintenances => this._correctiveMaintenances;
  set correctiveMaintenances(List<Maintenance> correctiveMaintenances) =>
      this._correctiveMaintenances = correctiveMaintenances;

  Equipment() {
    this._status = EquipmentHelper().getRoleByEnum(EquipmentStatus.ABLE);
  }

  Equipment.fromSpecial(String description, String status) {
    _description = description;
    _status = status;
  }

  Equipment.fromJson(Map<String, dynamic> json)
      : _description = json['description'],
        _status = json['status'],
        _correctiveMaintenances = json['correctiveMaintenances'];

  Map<String, dynamic> toJson() => {
        'description': _description,
        'status': _status,
        'correctiveMaintenances': _correctiveMaintenances,
      };
}
