import 'package:tirol_office_app/models/service_provider_model.dart';

class Maintenance {
  int _id;
  DateTime _dateTime;
  bool _hasOccurred;
  ServiceProvider _serviceProvider;

  int get id => this._id;
  set id(int value) => this._id = value;

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
        _hasOccurred = json['hasOccurred'],
        _serviceProvider = ServiceProvider.fromJson(json['serviceProvider']);

  Map<String, dynamic> toJson() => {
        'dateTime': _dateTime,
        'hasOccurred': _hasOccurred,
        'serviceProvider': _serviceProvider.toJson(),
      };
}
