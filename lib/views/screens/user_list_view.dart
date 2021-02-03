import 'package:flutter/material.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class UserListView extends StatelessWidget {
  final String title;
  final User user;
  final _users = FirestoreDB().db_users;

  UserListView({Key key, this.user, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(_users);

    return Scaffold(
      appBar: AppBarWidget(title),
      drawer: MenuDrawer(
        user: user,
      ),
    );
  }
}
