import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/views/screens/user_list_view.dart';

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
            child: Center(
              child: Text(
                user.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: usernameFontSize,
                    fontWeight: FontWeight.w500),
              ),
            ),
            width: double.infinity,
            height: userContainerHeight,
            color: Theme.of(context).appBarTheme.color,
          ),
          TextButton(
            onPressed: () => pushToUserListView(context),
            child: Text('Usuários'),
          ),
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
        builder: (context) => UserListView(title: title, user: user),
      ),
    );
  }
}
