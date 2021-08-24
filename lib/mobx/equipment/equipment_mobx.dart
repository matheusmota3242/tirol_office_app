import 'package:mobx/mobx.dart';
import 'package:tirol_office_app/models/equipment_model.dart';

part 'equipment_mobx.g.dart';

class EquipmentMobx = EquipmentMobxBase with _$EquipmentMobx;

abstract class EquipmentMobxBase with Store {
  int id;

  @observable
  String description;

  @observable
  String status;

  @computed
  get getDescription => this.description;

  @action
  setDescription(String description) => this.description = description;

  @computed
  get getStatus => this.status;

  @action
  setStatus(String status) {
    this.status = status;
  }

  @action
  changeStatus(String status) {
    switch (status) {
      case 'Funcionando':
        this.status = 'Danificado';
        break;
      case 'Danificado':
        this.status = 'Funcionando';
        break;
      default:
    }
  }
}
