import 'package:tirol_office_app/models/service_provider_model.dart';

class Maintenance {
  String _id;
  String _departmentId;
  String _equipmentDescription;
  DateTime _dateTime;
  bool _hasOccurred;
  ServiceProvider _serviceProvider;

  String get id => this._id;
  set id(String value) => this._id = value;

  String get departmentId => this._departmentId;
  set departmentId(String value) => this._departmentId = value;

  get equipmentDescription => this._equipmentDescription;
  set equipmentDescription(value) => this._equipmentDescription = value;

  get dateTime => this._dateTime;
  set dateTime(value) => this._dateTime = value;

  get hasOccurred => this._hasOccurred;
  set hasOccurred(value) => this._hasOccurred = value;

  get serviceProvider => this._serviceProvider;
  set serviceProvider(value) => this._serviceProvider = value;

  Maintenance() {
    _hasOccurred = false;
  }

  Maintenance.fromJson(Map<String, dynamic> json)
      : _dateTime = DateTime.parse(json['dateTime'].toDate().toString()),
        _departmentId = json['departmentId'],
        _equipmentDescription = json['equipmentDescription'],
        _hasOccurred = json['hasOccurred'],
        _serviceProvider = ServiceProvider.fromJson(json['serviceProvider']);

  Map<String, dynamic> toJson() => {
        'dateTime': _dateTime,
        'departmentId': _departmentId,
        'equipmentDescription': _equipmentDescription,
        'hasOccurred': _hasOccurred,
        'serviceProvider': _serviceProvider.toJson(),
      };
}
