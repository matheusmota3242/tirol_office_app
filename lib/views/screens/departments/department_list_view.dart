import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/departments/department_form_view.dart';
import 'package:tirol_office_app/views/screens/departments/department_test_view.dart';
import 'package:tirol_office_app/views/screens/empty_view.dart';
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
    String title = PageUtils.departaments;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        shadowColor: Colors.transparent,
        actions: [
          Visibility(
            visible: Provider.of<UserService>(context).getUser.role ==
                    'Administrador'
                ? true
                : false,
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DepartmentTestView(
                    currentDepartment: new Department(),
                    edit: false,
                  ),
                ),
              ),
              icon: Icon(
                Icons.add,
              ),
            ),
          )
        ],
      ),
      drawer: MenuDrawer(
        user: Provider.of<UserService>(context).getUser,
        currentPage: title,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
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
    if (docs.isEmpty) return EmptyView();
    return Container(
      color: theme.backgroundColor,
      padding: EdgeInsets.all(16),
      child: ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, index) {
            String name = docs[index]['name'];
            var data = docs[index].data();
            Department department = Department.fromJson(data);
            department.id = docs[index].id;
            return DepartmentCardItem(
              department: department,
              lastItem: index == (docs.length - 1) ? true : false,
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
