import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirol_office_app/db/firestore.dart';

class UnitService {
  static Future<QuerySnapshot> getUnits() async {
    return await FirestoreDB.dbUnits.get();
  }
}
