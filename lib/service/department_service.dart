import 'package:mobx/mobx.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';
import 'package:tirol_office_app/models/equipment_model.dart';

part 'department_service.g.dart';

class DepartmentService = DepartmentServiceBase with _$DepartmentService;

abstract class DepartmentServiceBase with Store {
  Department _editedDepartment;

  Department get editedDepartment => this._editedDepartment;
  set editedDepartment(Department value) => this._editedDepartment = value;

  @observable
  Department _currentDepartment = Department();

  @computed
  get currentDepartment => _currentDepartment;

  @action
  void setCurrentDepartment(Department department) =>
      this._currentDepartment = department;

  @observable
  Equipment currentEquipment;

  @computed
  get getCurrentEquipment => currentEquipment;

  @action
  setCurrentEquipment(Equipment equipment) => this.currentEquipment = equipment;

  String equipmentName;
  get getEquipmentName => equipmentName;
  setEquipmentName(String value) => equipmentName = value;

  var equipments = <Equipment>[];

  // Status do equipamento
  @observable
  String equipmentStatus = 'Funcionando';

  @computed
  get getEquipmentStatus => equipmentStatus;

  @action
  setEquipmentStatus(String value) => equipmentStatus = value;

  void save() {
    print('Entrou em save()');
    FirestoreDB()
        .db_departments
        .doc(currentDepartment.name)
        .set(currentDepartment.toJson());
  }

  void update() {
    FirestoreDB().db_departments.doc(editedDepartment.id).update(
          editedDepartment.toJson(),
        );
  }

  void modifyEquipment(Equipment editedEquipment) {
    _editedDepartment.equipments.forEach((element) {
      if (element.getId == editedEquipment.getId && editedDepartment != null) {
        element = editedEquipment;
      }
    });
  }
}
