import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class MaintenanceService {
  void saveCorrective(
      String departmentId, int equipmentId, Maintenance maintenance) async {
    var doc = await FirestoreDB.db_departments.doc(departmentId).get();
    Department department = Department.fromJson(doc.data());
    Equipment equipment = department.equipments[equipmentId];
    if (equipment.correctiveMaintenances == null)
      equipment.correctiveMaintenances = <Maintenance>[];
    equipment.correctiveMaintenances.add(maintenance);
    department.equipments[equipmentId] = equipment;
    try {
      print(maintenance.toJson());
      print(department.equipments[equipmentId].toJson());
      await FirestoreDB.db_departments
          .doc(departmentId)
          .update(department.toJson());
    } catch (e) {
      Toasts.showToast(content: 'Ocorreu um erro');
      print(e);
    }
  }
}
