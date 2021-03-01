import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirol_office_app/models/user_model.dart';

class UserService {
  User _user = User();

  void setUser(DocumentSnapshot snapshot) {
    _user.name = snapshot.data()['name'];
    _user.role = snapshot.data()['role'];
  }

  void cleanUser() {
    _user.name = null;
    _user.role = null;
  }

  getUser() {
    return _user;
  }
}
