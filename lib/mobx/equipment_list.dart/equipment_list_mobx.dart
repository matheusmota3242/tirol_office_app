import 'package:mobx/mobx.dart';
import 'package:tirol_office_app/mobx/equipment/equipment_mobx.dart';

part 'equipment_list_mobx.g.dart';

class EquipmentListMobx = EquipmentListMobxBase with _$EquipmentListMobx;

abstract class EquipmentListMobxBase with Store {
  @observable
  ObservableList<EquipmentMobx> equipmentList = ObservableList<EquipmentMobx>();

  @action
  void addEquipment(EquipmentMobx equipmentMobx) =>
      equipmentList.add(equipmentMobx);
}
