import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/screens/users/waiting_for_approval_view.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';
import 'package:tirol_office_app/views/widgets/process_card_item.dart';

class ProcessListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title = PageHelper.processes;
    final _authService = Provider.of<AuthService>(context);
    final _userService = Provider.of<UserService>(context);
    final _processes = FirestoreDB().db_processes;
    User _user = User();
    print('enroui');
    return StreamBuilder(
        stream: _processes.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Ocorreu um erro');
            case ConnectionState.waiting:
              return LoadingView();

              break;
            default:
              print("snapshot: " + snapshot.toString());
              if (snapshot.hasError) {
                return ErrorView();
              }

              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  _user = _userService.getUser;

                  if (_user.role ==
                      Role().getRoleByEnum(UserRole.WAITING_FOR_APPROVAL)) {
                    return WaitingForApprovalView();
                  } else if (_user.role ==
                          Role().getRoleByEnum(UserRole.ADMIN) ||
                      _user.role == Role().getRoleByEnum(UserRole.DEFAULT)) {
                    var _docs = snapshot.data.docs;
                    return Scaffold(
                      appBar: AppBarWidget(title),
                      drawer: MenuDrawer(
                        user: _user,
                        currentPage: title,
                      ),
                      body: Container(
                        color: Colors.grey[200],
                        padding: EdgeInsets.all(12.0),
                        child: ListView.builder(
                          itemCount: _docs.length,
                          itemBuilder: (context, index) {
                            var doc = _docs[index].data();
                            Process process = Process.fromJson(doc);
                            return ProcessCardItem(
                              process: process,
                              isProcessDetailsView: false,
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return ErrorView();
                  }
                } else {
                  return ErrorView();
                }
              }
              return LoadingView();
          }
        });
  }
}
