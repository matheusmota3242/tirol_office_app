import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/service/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection = FirestoreDB().db_users;
  UserService _userService = UserService();
  User user;

  Future loginWithEmail(
      {@required String email,
      @required String password,
      @required BuildContext context}) async {
    var result;
    try {
      result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      try {
        var userResponse =
            await FirestoreDB().db_users.doc(result.user.uid).get();
        _userService = Provider.of<UserService>(context, listen: false);
        _userService.setUser(userResponse);
      } catch (e) {
        print(e);
      }
    } catch (e) {}
    if (result != null) {
      return result.user != null;
    }
    return null;
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
        usersCollection.doc(value.user.uid).set({
          'name': name,
          'role': Role().getRoleByEnum(UserRole.WAITING_FOR_APPROVAL)
        });
      });
    } catch (e) {}
    return result.user != null;
  }
}
