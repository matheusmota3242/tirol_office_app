import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
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
          user.role == 'Administrador'
              ? Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 8.0),
                  child: TextButton(
                    onPressed: () => currentPage != PageUtils.PROCESSES_TITLE
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
                          PageUtils.PROCESSES_TITLE,
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          user.role == 'Administrador'
              ? Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: TextButton(
                    onPressed: () => currentPage != PageUtils.OBSERVATIONS_TITLE
                        ? pushToObservationListView(context)
                        : null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.assignment,
                          color: Colors.grey[700],
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          PageUtils.OBSERVATIONS_TITLE,
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          user.role == 'Administrador'
              ? Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: TextButton(
                    onPressed: () => currentPage != PageUtils.DEPARTIMENTS_TITLE
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
                          PageUtils.DEPARTIMENTS_TITLE,
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          user.role == 'Administrador'
              ? Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: TextButton(
                    onPressed: () => currentPage != PageUtils.UNITS_TITLE
                        ? pushToUnitsListView(context)
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
                          PageUtils.UNITS_TITLE,
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          user.role == 'Administrador'
              ? Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: TextButton(
                    onPressed: () => currentPage != PageUtils.MAINTENANCES_TITLE
                        ? pushToMaintenancesView(context)
                        : null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.home_repair_service,
                          color: Colors.grey[700],
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          PageUtils.MAINTENANCES_TITLE,
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          user.role == 'Administrador'
              ? Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: TextButton(
                      onPressed: () => currentPage != PageUtils.USERS_TITLE
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
                            PageUtils.USERS_TITLE,
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 16.0),
                          ),
                        ],
                      )),
                )
              : Container(),
          user.role == 'Administrador'
              ? Padding(
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
                          PageUtils.SERVICES_TITLE,
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: TextButton(
              onPressed: () => pushToPersonalInfoView(context),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.grey[700],
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    PageUtils.PERSONAL_INFO_TITLE,
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
        builder: (context) => UserListView(),
      ),
    );
  }

  /* Lista de departamentos */
  void pushToDepartmentListView(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RouteUtils.DEPARTMENTS, (Route<dynamic> route) => false);
  }

  /* Lista de equipamentos */
  void pushToEquipmentsView(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RouteUtils.EQUIPMENTS, (Route<dynamic> route) => false);
  }

  /* Lista de manutenções */
  void pushToMaintenancesView(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RouteUtils.MAINTENANCES, (Route<dynamic> route) => false);
  }

  /* Lista de processos */
  void pushToProcessListView(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RouteUtils.processes, (Route<dynamic> route) => false);
  }

  void pushToObservationListView(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RouteUtils.observations, (Route<dynamic> route) => false);
  }

  /* Lista de prestadores de serviço */
  pushToServiceProvidersView(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RouteUtils.serviceProviders, (Route<dynamic> route) => false);
  }

  pushToPersonalInfoView(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RouteUtils.personalInfo, (Route<dynamic> route) => false);
  }

  pushToUnitsListView(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, RouteUtils.units, (route) => false);
  }

  /* Logout */
  void logout(BuildContext context) {
    Dialogs().showLogoutDialog(context);
  }
}
