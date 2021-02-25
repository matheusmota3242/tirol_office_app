class EquipmentHelper {
  Map<EquipmentStatus, String> map = {
    EquipmentStatus.ABLE: 'Funcionando',
    EquipmentStatus.DISABLE: 'Danificado'
  };

  String getRoleByEnum(EquipmentStatus status) {
    return map[status];
  }
}

enum EquipmentStatus { ABLE, DISABLE }
