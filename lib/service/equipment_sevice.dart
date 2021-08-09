import 'package:mobx/mobx.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/department_model.dart';
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

  getEquipment(String departmentId, String equipmentDescription) async {
    var doc = await FirestoreDB.departments.doc(departmentId).get();
    Department department = Department.fromJson(doc.data());
    List<Equipment> equipments = department.equipments;
    return equipments
        .firstWhere((element) => element.description == equipmentDescription);
  }
}
