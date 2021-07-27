import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class MaintenanceService {
  saveCorrective(String departmentId, String equipmentDescription,
      Maintenance maintenance) async {
    var doc = await FirestoreDB.db_departments.doc(departmentId).get();
    Department department = Department.fromJson(doc.data());

    int equipmentIndex = department.equipments
        .map((e) => e.description)
        .toList()
        .indexOf(equipmentDescription);

    Equipment equipment = department.equipments[equipmentIndex];

    if (equipment.correctiveMaintenances == null)
      equipment.correctiveMaintenances = <Maintenance>[];

    bool alreadyExists = equipment.correctiveMaintenances.any((el) =>
        el.serviceProvider.name == maintenance.serviceProvider.name &&
        el.dateTime == maintenance.dateTime);
    var result;
    if (alreadyExists) {
      Toasts.showToast(content: 'Manutenção já existe');
    } else {
      equipment.correctiveMaintenances.add(maintenance);
      department.equipments[equipmentIndex] = equipment;
      try {
        await FirestoreDB.db_departments
            .doc(departmentId)
            .update(department.toJson());
        result = equipment;
      } catch (e) {
        Toasts.showToast(content: 'Ocorreu um erro');
        print(e);
      }
      return result;
    }
  }

  deleteCorrective(String departmentId, String equipmentDescription,
      Maintenance maintenance) async {
    var doc = await FirestoreDB.db_departments.doc(departmentId).get();
    Department department = Department.fromJson(doc.data());
    int indexOfEquipment = department.equipments
        .map((e) => e.description)
        .toList()
        .indexOf(equipmentDescription);
    Equipment equipment = department.equipments
        .firstWhere((element) => element.description == equipmentDescription);
    equipment.correctiveMaintenances.removeWhere((el) =>
        el.serviceProvider.name == maintenance.serviceProvider.name &&
        el.dateTime == maintenance.dateTime);
    department.equipments[indexOfEquipment] = equipment;
    var result;
    try {
      await FirestoreDB.db_departments
          .doc(departmentId)
          .update(department.toJson());
      result = true;
    } catch (e) {
      Toasts.showToast(content: 'Ocorreu um erro');
      result = null;
    }
    return result;
  }
}
