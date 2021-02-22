import 'package:mobx/mobx.dart';
import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';
import 'package:tirol_office_app/models/equipment_model.dart';

part 'department_service.g.dart';

class DepartmentService = DepartmentServiceBase with _$DepartmentService;

abstract class DepartmentServiceBase with Store {
  @observable
  Equipment equipment;

  @computed
  get getEquipment => equipment;

  @action
  setEquipment(Equipment equipment) => this.equipment = equipment;

  String equipmentName;

  get getEquipmentName => equipmentName;

  setEquipmentName(String value) => equipmentName = value;

  // Status do equipamento
  @observable
  String equipmentStatus = 'Funcionando';

  @computed
  get getEquipmentStatus => equipmentStatus;

  @action
  setEquipmentStatus(String value) => equipmentStatus = value;

  void instantiateEquipment() {
    EquipmentStatus statusEnum;
    if (equipmentStatus == 'Funcionando') {
      statusEnum = EquipmentStatus.ABLE;
    } else {
      statusEnum = EquipmentStatus.DISABLE;
    }
    equipment = new Equipment(equipmentName, statusEnum);
  }
}
