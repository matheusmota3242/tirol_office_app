import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
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

    // if (arguments['process'] == null) {
    //   process = arguments['process'];
    // } else {
    //   process = _processService.currentProcess;
    // }

    // print(_userService.getUser.name);
    // if (arguments != null) print(arguments['process']);

    return Scaffold(
      appBar: AppBarWidget(PageHelper.processDetails),
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
          return Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                ProcessCardItem(
                  isProcessDetailsView: true,
                  process: process,
                ),
                SizedBox(
                  height: 12,
                ),
                Card(
                  shadowColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    height: double.infinity,
                    width: double.infinity,
                    // child: ListView.builder(
                    //   itemCount: _departmentService
                    //       .currentDepartment.equipments.length,
                    //   itemBuilder: (context, index) {
                    //     var equipments =
                    //         _departmentService.currentDepartment.equipments;
                    //     print(equipments[index].getDescription);
                    //     return Text(equipments[0].getDescription);
                    //   },
                    // ),
                  ),
                )
              ],
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
              child: Text(process.departmentId),
            ),
          )
        ],
      ),
    );
  }
}
