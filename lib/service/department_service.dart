import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/process_model.dart';
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
    var snapshot = await FirestoreDB.db_departments.get();
    if (!departmentAlreadyExists(snapshot, department.name)) {
      try {
        await FirestoreDB.db_departments.add(department.toJson());
        Toasts.showToast(content: 'Departamento criado com sucesso');
        result = true;
      } catch (e) {
        Toasts.showToast(content: 'Ocorreu um erro');
      }
    }
    return result;
  }

  Future<bool> update(Department department) async {
    bool result = false;
    var snapshot = await FirestoreDB.db_departments.get();
    if (!departmentAlreadyExists(snapshot, department.name)) {
      try {
        await FirestoreDB.db_departments
            .doc(department.id)
            .update(department.toJson());
        Toasts.showToast(content: 'Departamento editado com sucesso');
        result = true;
      } catch (e) {
        Toasts.showToast(content: 'Ocorreu um erro');
      }
    }
    return result;
  }

  void remove(Department department) async {
    try {
      await FirestoreDB.db_departments.doc(department.id).delete();
    } catch (e) {
      Toasts.showToast(content: 'Ocorreu um erro');
    }
  }

  void modifyEquipment(Equipment editedEquipment) {
    _editedDepartment.equipments.forEach((element) {
      if (element.getId == editedEquipment.id && editedDepartment != null) {
        element = editedEquipment;
      }
    });
  }

  queryByProcess(Process process) async {
    return await FirestoreDB.db_departments
        .where('name', isEqualTo: process.departmentId)
        .get();
  }

  bool departmentAlreadyExists(QuerySnapshot snapshot, String name) =>
      snapshot.docs
          .any((element) => Department.fromJson(element.data()).name == name);
}
