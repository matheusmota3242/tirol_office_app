import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirol_office_app/models/user_model.dart';

class FirestoreDB {
  CollectionReference db_users = FirebaseFirestore.instance.collection("users");
  CollectionReference db_departments =
      FirebaseFirestore.instance.collection("departments");
  CollectionReference db_processes =
      FirebaseFirestore.instance.collection("processes");
  CollectionReference db_service_providers =
      FirebaseFirestore.instance.collection("service_providers");
  CollectionReference db_observations =
      FirebaseFirestore.instance.collection("observations");

  findById(String uid) async {
    var json = await db_users.doc(uid).get();
    var user = User.fromJson(json.data());
    return user;
  }
}
