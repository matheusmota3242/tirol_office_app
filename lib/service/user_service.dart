import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/user_model.dart';

class UserService {
  User _user = User();

  void setUserByUid(DocumentSnapshot snapshot, String uid) {
    _user.id = uid;
    _user.name = snapshot.data()['name'];
    _user.role = snapshot.data()['role'];
  }

  void setUser(User user) {
    _user = user;
  }

  void cleanUser() {
    _user.name = null;
    _user.role = null;
  }

  void findById(String uid) async {
    var data;
    FirestoreDB().db_users.doc(uid).get().then((value) {
      data = value.data();
      _user = User.fromJson(data);
    });
    print('findById');
  }

  get getUser => _user;
}
