import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDB {
  CollectionReference db_users = FirebaseFirestore.instance.collection("users");
}
