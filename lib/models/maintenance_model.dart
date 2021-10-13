import 'package:tirol_office_app/models/service_provider_model.dart';

class Maintenance {
  String _id;
  String _unitName;
  String _departmentName;
  String _equipmentDescription;
  DateTime _dateTime;
  bool _hasOccurred;
  ServiceProvider _serviceProvider;

  String get id => this._id;
  set id(String value) => this._id = value;

  String get departmentName => this._departmentName;
  set departmentName(String value) => this._departmentName = value;

  get equipmentDescription => this._equipmentDescription;
  set equipmentDescription(value) => this._equipmentDescription = value;

  get dateTime => this._dateTime;
  set dateTime(value) => this._dateTime = value;

  get hasOccurred => this._hasOccurred;
  set hasOccurred(value) => this._hasOccurred = value;

  get serviceProvider => this._serviceProvider;
  set serviceProvider(value) => this._serviceProvider = value;

  String get unitName => this._unitName;
  set unitName(String value) => this._unitName = value;

  Maintenance() {
    _hasOccurred = false;
  }

  Maintenance.fromJson(Map<String, dynamic> json)
      : _dateTime = DateTime.parse(json['dateTime'].toDate().toString()),
        _unitName = json['unitName'],
        _departmentName = json['departmentName'],
        _equipmentDescription = json['equipmentDescription'],
        _hasOccurred = json['hasOccurred'],
        _serviceProvider = ServiceProvider.fromJson(json['serviceProvider']);

  Map<String, dynamic> toJson() => {
        'dateTime': _dateTime,
        'departmentName': _departmentName,
        'equipmentDescription': _equipmentDescription,
        'hasOccurred': _hasOccurred,
        'serviceProvider': _serviceProvider.toJson(),
        'unitName': _unitName,
      };
}
