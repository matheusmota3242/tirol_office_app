import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/views/screens/departments/department_list_view.dart';
import 'package:tirol_office_app/views/screens/users/user_list_view.dart';

class MenuDrawer extends StatelessWidget {
  final User user;
  const MenuDrawer({Key key, this.user}) : super(key: key);
  static const double usernameFontSize = 20.0;
  static const double userContainerHeight = 180.0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                user.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: usernameFontSize,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(
                '${user.role}',
                style: TextStyle(color: Colors.white),
              ),
            ]),
            width: double.infinity,
            height: userContainerHeight,
            color: Theme.of(context).appBarTheme.color,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: TextButton(
              onPressed: () => pushToUserListView(context),
              child: Text(
                'Usuários',
                style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: TextButton(
              onPressed: () => pushToDepartmentListView(context),
              child: Text(
                'Departamentos',
                style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
              ),
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  void pushToUserListView(BuildContext context) {
    String title = 'Usuários';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserListView(title: title, currentUser: user),
      ),
    );
  }

  void pushToDepartmentListView(BuildContext context) {
    String title = 'Departamentos';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DepartmentListView(title: title, currentUser: user),
      ),
    );
  }
}
