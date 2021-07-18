import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';

class SpecialEquipment extends Equipment {
  int _interval;
  List<Maintenance> _preventiveMaintenances;

  int get interval => this._interval;
  set interval(int value) => this._interval = value;

  List<Maintenance> get preventiveMaintenances => this._preventiveMaintenances;
  set preventiveMaintenances(List<Maintenance> preventiveMaintenances) =>
      this._preventiveMaintenances = preventiveMaintenances;

  SpecialEquipment() : super();

  SpecialEquipment.fromJson(Map<String, dynamic> json)
      : _interval = json['interval'],
        _preventiveMaintenances = json['preventiveMaintenances'],
        super.fromJson(json);

  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'interval': _interval,
      'preventiveMaintenances': _preventiveMaintenances
    });
    return json;
  }
}
