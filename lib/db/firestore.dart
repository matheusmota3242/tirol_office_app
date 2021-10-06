import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirol_office_app/models/user_model.dart';

class FirestoreDB {
  static CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  static CollectionReference departments =
      FirebaseFirestore.instance.collection("departments");
  static CollectionReference dbProcesses =
      FirebaseFirestore.instance.collection("processes");
  static CollectionReference dbServiceProviders =
      FirebaseFirestore.instance.collection("service_providers");
  static CollectionReference dbObservations =
      FirebaseFirestore.instance.collection("observations");
  static CollectionReference dbMaintenances =
      FirebaseFirestore.instance.collection("maintenances");
  static CollectionReference dbUnits =
      FirebaseFirestore.instance.collection("units");

  findById(String uid) async {
    var json = await users.doc(uid).get();
    var user = User.fromJson(json.data());
    return user;
  }
}
