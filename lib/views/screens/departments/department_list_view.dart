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
              return Center(
                child: CircularProgressIndicator(),
              );
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
            List<Equipment> equipments = department.getEquipments;
            return ListTileTheme(
              contentPadding: EdgeInsets.all(0),
              child: Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                    title: Text(
                      name,
                      style: theme.textTheme.headline6,
                    ),
                    tilePadding: EdgeInsets.all(0),
                    childrenPadding: EdgeInsets.all(0),
                    //childrenPadding: EdgeInsets.all(0),
                    children: equipments.isNotEmpty
                        ? [
                            Card(
                              shadowColor: Colors.transparent,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      // Text('Equipamentos',
                                      //     style: theme.textTheme.subtitle1),
                                      equipments
                                          .map(
                                            (equipment) => Container(
                                              padding: equipments.last ==
                                                      equipment
                                                  ? EdgeInsets.only(bottom: 0)
                                                  : EdgeInsets.only(bottom: 12),
                                              child: Container(
                                                width: double.maxFinite,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(equipment
                                                        .getDescription),
                                                    Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                            )
                          ]
                        : [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Não há equipamentos nesse departamento.',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ]),
              ),
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
