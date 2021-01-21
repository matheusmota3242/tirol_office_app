import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future loginWithEmail(
      {@required String email, @required String password}) async {
    var result;
    try {
      result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      return e.message;
    }
    return result.user != null;
  }

  Future signUp({@required String email, @required String password}) async {
    var result;
    try {
      result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(result.user);
    } catch (e) {
      return e.message;
    }
    return result.user != null;
  }
}
