import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/unit.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class UnitService {
  static Future<QuerySnapshot> getUnits() async {
    return await FirestoreDB.dbUnits.get();
  }

  add(Unit unit) async {
    try {
      await FirestoreDB.dbUnits.add(unit.toJson());
      Toasts.showToast(content: 'Unidade cadastrada com sucesso');
    } catch (e) {
      Toasts.showWarningToast(content: 'Erro ao cadastrar nova unidade');
    }
  }

  _getDepartmentsByOldUnitName(String oldUnitName) async {
    return await FirestoreDB.departments
        .where('unitName', isEqualTo: oldUnitName)
        .get();
  }

  _updateDepartmentsUnitName(String unitName, String oldUnitName) async {
    QuerySnapshot snapshot = await _getDepartmentsByOldUnitName(oldUnitName);
    if (snapshot.size > 0) {
      for (var i = 0; i < snapshot.size; i++) {
        await FirestoreDB.departments
            .doc(snapshot.docs[i].id)
            .update({'unitName': unitName});
      }
    }
  }

  update(Unit unit, String oldUnitName) async {
    if (unit.name != oldUnitName) {
      _updateDepartmentsUnitName(unit.name, oldUnitName);
    }

    try {
      await FirestoreDB.dbUnits.doc(unit.id).update(unit.toJson());
      Toasts.showToast(content: 'Unidade editada com sucesso');
    } catch (e) {
      Toasts.showWarningToast(content: 'Erro ao editar unidade');
    }
  }

  remove(String id) async {
    await FirestoreDB.dbUnits.doc(id).delete();
  }
}
