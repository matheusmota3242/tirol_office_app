import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  CollectionReference usersCollection = FirestoreDB.users;
  UserService _userService = UserService();
  auth.User user;

  Future loginWithEmail(
      {@required String email,
      @required String password,
      @required BuildContext context}) async {
    bool result;
    try {
      var credentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      var userResponse =
          await FirestoreDB.users.doc(credentials.user.uid).get();
      _userService = Provider.of<UserService>(context, listen: false);
      _userService.setUserByUid(userResponse, credentials.user.uid);
      var user = User.fromJson(userResponse.data());
      await saveUserInMemory(user.name, user.role, userResponse.id);
      result = true;
    } catch (e) {
      result = false;
      Toasts.showToast(content: 'Credenciais inválidas');
    }

    return result;
  }

  saveUserInMemory(String username, String role, String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', id);
  }

  void cleanUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
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
          'role': Role().getRoleByEnum(UserRole.WAITING_FOR_APPROVAL),
          'email': email
        });
      });
    } on auth.FirebaseAuthException catch (fae) {
      if (fae.code == 'email-already-in-use')
        Toasts.showToast(content: 'E-mail já utilizado');
    } on Exception catch (e) {
      print(e);
    }
    return result.user != null;
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    _userService = Provider.of<UserService>(context, listen: false);
    _userService.cleanUser();
    cleanUserInfo();
    Navigator.pushNamedAndRemoveUntil(
        context, RouteUtils.login, (Route<dynamic> route) => false);
  }

  update(User user, BuildContext context) async {
    bool result = await updateEmail(user.email, context);
    if (result)
      await FirestoreDB.users
          .doc(user.id)
          .update({'email': user.email, 'name': user.name});
  }

  updateEmail(String newEmail, BuildContext context) async {
    bool result = false;
    try {
      await _auth.currentUser.updateEmail(newEmail);
      result = true;
    } catch (e) {
      Toasts.showToast(content: 'Ocorreu um erro');
      print(e.toString());
      logout(context);
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', newEmail);
    return result;
  }

  Future<bool> updatePassword(String newPassword) async {
    bool result = false;
    try {
      await _auth.currentUser.updatePassword(newPassword);
      result = true;
    } catch (e) {
      Toasts.showToast(content: 'Ocorreu um erro');
    }
    return result;
  }

  Future<bool> validateUserPassword(String password) async {
    var credential = auth.EmailAuthProvider.credential(
        email: _auth.currentUser.email, password: password);
    bool result = false;
    try {
      await _auth.currentUser.reauthenticateWithCredential(credential);
      result = true;
    } catch (e) {}
    return result;
  }

  Future<bool> validateUserEmail(String email, BuildContext context) async {
    bool result = false;
    try {
      var response = await _auth.fetchSignInMethodsForEmail(email);
      if (response.isEmpty) {
        Toasts.showToast(content: 'E-mail não cadastrado');
      } else {
        result = true;
        Toasts.showToast(content: 'E-mail enviado com sucesso');
        Navigator.pop(context);
      }
    } catch (e) {
      Toasts.showToast(content: 'E-mail inválido');
    }
    return result;
  }

  sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Toasts.showToast(content: 'Confira sua caixa de entrada');
    } catch (e) {
      Toasts.showToast(content: 'E-mail não cadastrado');
    }
  }
}
