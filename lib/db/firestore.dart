import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDB {
  var db = FirebaseFirestore.instance.collection("roles");
}
