import 'package:mobx/mobx.dart';
import 'package:tirol_office_app/models/equipment_model.dart';

class EquipmentService {
  Equipment _currentEquipment;

  get currentEquipment => _currentEquipment;
  set currentEquipment(Equipment equipment) => _currentEquipment = equipment;

  @observable
  String currentEquipmentStatus;

  @computed
  get getCurrentEquipmentStatus => currentEquipmentStatus;

  @action
  void setCurrentEquipmentStatus(String value) =>
      currentEquipmentStatus = value;
}
