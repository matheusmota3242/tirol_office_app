import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/helpers/route_helper.dart';

import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/views/screens/departments/department_list_view.dart';
import 'package:tirol_office_app/views/screens/users/user_list_view.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';

class MenuDrawer extends StatelessWidget {
  final User user;
  final String currentPage;
  const MenuDrawer({Key key, this.user, this.currentPage}) : super(key: key);
  static const double usernameFontSize = 20.0;
  static const double userContainerHeight = 180.0;

  @override
  Widget build(BuildContext context) {
    print(user.name);
    return Drawer(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.color,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
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
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, top: 8.0),
            child: TextButton(
              onPressed: () => currentPage != PageHelper.processes
                  ? pushToProcessListView(context)
                  : null,
              child: Row(
                children: [
                  Icon(
                    Icons.qr_code,
                    color: Colors.grey[700],
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    PageHelper.processes,
                    style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: TextButton(
              onPressed: () => currentPage != PageHelper.departaments
                  ? pushToDepartmentListView(context)
                  : null,
              child: Row(
                children: [
                  Icon(
                    Icons.room_preferences,
                    color: Colors.grey[700],
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    PageHelper.departaments,
                    style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: TextButton(
                onPressed: () => currentPage != PageHelper.users
                    ? pushToUserListView(context)
                    : null,
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      PageHelper.users,
                      style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: TextButton(
              onPressed: () => pushToServiceProvidersView(context),
              child: Row(
                children: [
                  Icon(
                    Icons.miscellaneous_services,
                    color: Colors.grey[700],
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    PageHelper.services,
                    style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: TextButton(
              onPressed: () => logout(context),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.grey[700],
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Sair',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                  ),
                ],
              ),
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  void pushToUserListView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserListView(currentUser: user),
      ),
    );
  }

  // Lista de departamentos
  void pushToDepartmentListView(BuildContext context) {
    Navigator.pushNamed(context, RouteHelper.departments);
  }

  // Lista de processos
  void pushToProcessListView(BuildContext context) {
    Navigator.pushNamed(context, RouteHelper.processes);
  }

  // Lista de prestadores de serviço
  pushToServiceProvidersView(BuildContext context) {
    Navigator.pushNamed(context, RouteHelper.serviceProviders);
  }

  // Logout
  void logout(BuildContext context) {
    Dialogs().showLogoutDialog(context);
  }
}
