import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

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

  Future<bool> save(Department department) async {
    bool result = false;
    var snapshot = await FirestoreDB.departments.get();
    if (departmentAlreadyExists(
            snapshot, department.name, department.unitName) ==
        false) {
      try {
        await FirestoreDB.departments.add(department.toJson());
        Toasts.showToast(content: 'Departamento criado com sucesso');
        result = true;
      } catch (e) {
        Toasts.showWarningToast(content: 'Ocorreu um erro');
      }
    } else {
      Toasts.showToast(content: 'Departamento já existe');
    }
    return result;
  }

  Future<bool> update(Department department) async {
    bool result = false;
    var snapshot = await FirestoreDB.departments.get();
    if (departmentAlreadyExists(
            snapshot, department.name, department.unitName) ==
        false) {
      try {
        await FirestoreDB.departments
            .doc(department.id)
            .update(department.toJson());
        Toasts.showToast(content: 'Departamento editado com sucesso');
        result = true;
      } catch (e) {
        Toasts.showToast(content: 'Erro ao editar departamento');
      }
    }

    return result;
  }

  remove(String departmentId) async {
    bool result = false;
    try {
      await FirestoreDB.departments.doc(departmentId).delete();
      result = true;
      Toasts.showToast(content: 'Departamento removido com sucesso');
    } catch (e) {
      Toasts.showToast(content: 'Ocorreu um erro');
    }
    return result;
  }

  void modifyEquipment(Equipment editedEquipment) {
    _editedDepartment.equipments.forEach((element) {
      if (element.getId == editedEquipment.id && editedDepartment != null) {
        element = editedEquipment;
      }
    });
  }

  bool departmentAlreadyExists(
          QuerySnapshot snapshot, String departmentName, String unitName) =>
      snapshot.docs.any((element) {
        Department department = Department.fromJson(element.data());
        return department.name == departmentName &&
            department.unitName == unitName;
      });
}
