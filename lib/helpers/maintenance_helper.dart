import 'package:tirol_office_app/models/maintenance_model.dart';
import 'package:tirol_office_app/utils/datetime_utils.dart';

class MaintenanceHelper {
  static String convertToMaintenanceId(Maintenance maintenance) {
    return DateTimeUtils.compressDate(maintenance.dateTime) +
        maintenance.departmentName +
        maintenance.equipmentDescription.replaceAll(' ', '');
  }
}
