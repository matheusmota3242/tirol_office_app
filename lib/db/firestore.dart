import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirol_office_app/models/user_model.dart';

class FirestoreDB {
  static CollectionReference db_users =
      FirebaseFirestore.instance.collection("users");
  static CollectionReference db_departments =
      FirebaseFirestore.instance.collection("departments");
  static CollectionReference db_processes =
      FirebaseFirestore.instance.collection("processes");
  static CollectionReference db_service_providers =
      FirebaseFirestore.instance.collection("service_providers");
  static CollectionReference db_observations =
      FirebaseFirestore.instance.collection("observations");

  findById(String uid) async {
    var json = await db_users.doc(uid).get();
    var user = User.fromJson(json.data());
    return user;
  }
}
