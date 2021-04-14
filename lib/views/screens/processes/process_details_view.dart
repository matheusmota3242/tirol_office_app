import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/service/process_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';
import 'package:tirol_office_app/views/widgets/process_card_item.dart';

class ProcessDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    var _processService = Provider.of<ProcessService>(context);
    var _departmentService = Provider.of<DepartmentService>(context);
    var _userService = Provider.of<UserService>(context);

    Process process = arguments == null
        ? _processService.currentProcess
        : arguments['process'];

    _userService.getUser.id == process.getUserId
        ? print('Usuário dono do processo')
        : print('Usuário nao e dono do processo');

    // if (arguments['process'] == null) {
    //   process = arguments['process'];
    // } else {
    //   process = _processService.currentProcess;
    // }

    // print(_userService.getUser.name);
    // if (arguments != null) print(arguments['process']);

    return Scaffold(
      appBar: AppBar(
        title: Text(PageHelper.processDetails),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: FirestoreDB().db_departments.doc(process.departmentId).get(),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return LoadingView();

          if (snapshot.hasError) return ErrorView();

          // var data = snapshot.data;
          // print(process.getResponsible);
          // print(data['name']);
          return Scaffold(
            body: Container(
              color: Theme.of(context).buttonColor,
              padding: EdgeInsets.all(12.0),
              child: ListView(
                children: [
                  ProcessCardItem(
                    isProcessDetailsView: true,
                    isLastItem: false,
                    process: process,
                  ),
                  // SizedBox(
                  //   height: 12,
                  // ),
                  FutureBuilder(
                      future: _departmentService.queryByProcess(process),
                      builder: (_, AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return LoadingView();
                          case ConnectionState.none:
                            return ErrorView();
                            break;
                          default:
                            print(snapshot.data.docs[0].data());
                            Department department = Department.fromJson(
                                snapshot.data.docs[0].data());

                            return Column(
                              children: [
                                Card(
                                  margin: EdgeInsets.all(0),
                                  shadowColor: Colors.transparent,
                                  child: Container(
                                    width: double.maxFinite,
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Equipamentos',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Column(
                                          children: department.equipments
                                              .map(
                                                  (e) => Text(e.getDescription))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Card(
                                  margin: EdgeInsets.all(0),
                                  child: Container(
                                    padding: EdgeInsets.all(20.0),
                                    width: double.maxFinite,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Observações',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            labelStyle: TextStyle(
                                                color: Colors.grey[700],
                                                height: 0.9,
                                                fontWeight: FontWeight.w600),
                                            filled: true,
                                            counterStyle:
                                                TextStyle(color: Colors.red),
                                            contentPadding: EdgeInsets.all(
                                              10.0,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                        }
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  x(Process process) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          ProcessCardItem(
            process: process,
            isProcessDetailsView: true,
          ),
          SizedBox(
            height: 12.0,
          ),
          Card(
            shadowColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [],
              ),
            ),
          )
        ],
      ),
    );
  }
}
