import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';

class EquipmentHelper {
  Map<EquipmentStatus, String> map = {
    EquipmentStatus.ABLE: 'Funcionando',
    EquipmentStatus.DISABLE: 'Danificado'
  };

  String getRoleByEnum(EquipmentStatus status) {
    return map[status];
  }
}
