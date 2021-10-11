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
}
