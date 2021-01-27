import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tirol_office_app/db/firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection = FirestoreDB().db_users;
  User user;

  Future loginWithEmail(
      {@required String email, @required String password}) async {
    var result;
    try {
      result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } catch (e) {}
    return result.user != null;
  }

  Future signUp(
      {@required String email,
      @required String password,
      @required String name}) async {
    var result;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        result = value;
        usersCollection.doc(value.user.uid).set({'name': name, 'role': false});
      });
    } catch (e) {}
    return result.user != null;
  }
}
