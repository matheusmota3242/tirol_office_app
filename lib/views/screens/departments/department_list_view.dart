import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/service/user_service.dart';

import 'package:tirol_office_app/views/screens/departments/department_form_view.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/widgets/department_card_item.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class DepartmentListView extends StatelessWidget {
  //final Object title;
  //final User currentUser;

  const DepartmentListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = PageHelper.departaments;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => pushToDepartmentFormView(context),
            icon: Icon(
              Icons.add,
            ),
          )
        ],
      ),
      drawer: MenuDrawer(
        user: Provider.of<UserService>(context).getUser,
        currentPage: title,
      ),
      body: StreamBuilder(
        stream: FirestoreDB().db_departments.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingView();
              break;
            default:
              return setBody(context, snapshot);
          }
        },
      ),
    );
  }

  Widget setBody(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) return ErrorView();

    if (!snapshot.hasData)
      return Center(
        child: Text('Vazio'),
      );

    var docs = snapshot.data.docs;
    var theme = Theme.of(context);
    return Container(
      color: theme.backgroundColor,
      padding: EdgeInsets.all(12),
      child: ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, index) {
            String name = docs[index]['name'];
            var data = docs[index].data();
            Department department = Department.fromJson(data);
            department.id = docs[index].id;
            return DepartmentCardItem(
              department: department,
            );
          }),
    );
  }

  void pushToDepartmentFormView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DepartmentFormView(),
      ),
    );
  }
}
