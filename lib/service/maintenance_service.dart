import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/maintenance_helper.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';
import 'package:tirol_office_app/utils/datetime_utils.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class MaintenanceService {
  Future<QuerySnapshot> getByEquipmentAndDepartment(
      String departmentId, equipmentDescription) async {
    return await FirestoreDB.db_maintenances
        .where('departmentId', isEqualTo: departmentId)
        .where('equipmentDescription', isEqualTo: equipmentDescription)
        .orderBy('dateTime', descending: true)
        .get();
  }

  getAll() async {
    return await FirestoreDB.db_maintenances
        .orderBy('dateTime', descending: true)
        .get();
  }

  save(Maintenance maintenance) async {
    bool result = false;
    String maintenanceId =
        MaintenanceHelper.convertToMaintenanceId(maintenance);
    try {
      var doc = await FirestoreDB.db_maintenances.doc(maintenanceId).get();
      if (doc.exists) {
        Toasts.showToast(content: 'Manutenção já existe');
      } else {
        await FirestoreDB.db_maintenances
            .doc(maintenanceId)
            .set(maintenance.toJson());
        result = true;
      }
    } catch (e) {
      Toasts.showToast(content: 'Ocorreu um erro');
      print(e);
    }

    return result;
  }

  delete(String maintenanceId) async {
    bool result = false;
    try {
      await FirestoreDB.db_maintenances.doc(maintenanceId).delete();
      Toasts.showToast(content: 'Manutenção removida com sucesso');
      result = true;
    } catch (e) {
      Toasts.showToast(content: 'Ocorreu um erro');
    }
    return true;
  }

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
        el.dateTime.day == maintenance.dateTime.day &&
        el.dateTime.month == maintenance.dateTime.month &&
        el.dateTime.year == maintenance.dateTime.year);
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
        el.dateTime.day == maintenance.dateTime.day &&
        el.dateTime.month == maintenance.dateTime.month &&
        el.dateTime.year == maintenance.dateTime.year);
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

  updateHasOccured(Maintenance maintenance) async {
    bool result = false;
    if (!maintenance.hasOccurred &&
        DateTimeUtils.firstHour(maintenance.dateTime)
            .isAfter(DateTimeUtils.firstHour(DateTime.now()))) {
      Toasts.showToast(content: 'Impossível atualizar antes da data marcada');
    } else {
      try {
        await FirestoreDB.db_maintenances
            .doc(maintenance.id)
            .update({'hasOccurred': !maintenance.hasOccurred});
        result = true;
      } catch (e) {
        Toasts.showToast(content: 'Ocorreu um erro');
        log(e.toString());
      }
    }

    return result;
  }

  // updateHasOccured(String departmentId, String equipmentDescription,
  //     Maintenance maintenance) async {
  //   var doc = await FirestoreDB.db_departments.doc(departmentId).get();
  //   Department department = Department.fromJson(doc.data());
  //   int indexOfEquipment = department.equipments
  //       .map((e) => e.description)
  //       .toList()
  //       .indexOf(equipmentDescription);
  //   Equipment equipment = department.equipments
  //       .firstWhere((element) => element.description == equipmentDescription);

  //   int indexOfMaintenance = equipment.correctiveMaintenances
  //       .map((e) => e.serviceProvider.name)
  //       .toList()
  //       .indexOf(maintenance.serviceProvider.name);
  //   equipment.correctiveMaintenances[indexOfMaintenance].hasOccurred =
  //       !equipment.correctiveMaintenances[indexOfMaintenance].hasOccurred;

  //   department.equipments[indexOfEquipment] = equipment;
  //   var result;
  //   try {
  //     await FirestoreDB.db_departments
  //         .doc(departmentId)
  //         .update(department.toJson());
  //     Toasts.showToast(content: 'Item atualizado com sucesso');
  //     result = true;
  //   } catch (e) {
  //     Toasts.showToast(content: 'Ocorreu um erro');
  //     result = null;
  //   }
  //   return result;
  // }
}
