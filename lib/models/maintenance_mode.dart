import 'package:tirol_office_app/models/service_provider_model.dart';

class Maintenance {
  DateTime _dateTime;
  bool _hasOccurred;
  ServiceProvider _serviceProvider;

  get dateTime => this._dateTime;
  set dateTime(value) => this._dateTime = value;

  get hasOccurred => this._hasOccurred;
  set hasOccurred(value) => this._hasOccurred = value;

  get serviceProvider => this._serviceProvider;
  set serviceProvider(value) => this._serviceProvider = value;
}
