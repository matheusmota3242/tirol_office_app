import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDB {
  CollectionReference db_users = FirebaseFirestore.instance.collection("users");
  CollectionReference db_departments =
      FirebaseFirestore.instance.collection("departments");
  CollectionReference db_processes =
      FirebaseFirestore.instance.collection("processes");
}
