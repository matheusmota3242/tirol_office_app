import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/departments/department_form_view.dart';
import 'package:tirol_office_app/views/screens/departments/department_test_view.dart';
import 'package:tirol_office_app/views/screens/empty_view.dart';
import 'package:tirol_office_app/views/screens/equipments/equipment_details_view.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/widgets/equipment_status_widget.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class DepartmentListView extends StatelessWidget {
  const DepartmentListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = PageUtils.DEPARTIMENTS_TITLE;
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
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, index) {
            String name = docs[index]['name'];
            var data = docs[index].data();
            Department department = Department.fromJson(data);
            department.id = docs[index].id;
            return Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.all(0),
                title: Text(department.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: atLeastOneDamaged(department.equipments)
                            ? Colors.red
                            : Colors.black)),
                childrenPadding: EdgeInsets.all(0),
                children: department.equipments
                    .map((e) => Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                        child: InkWell(
                          onTap: () => pushToEquipmentDetailsView(
                              context, e, department.name),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.description,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey[700])),
                              EquipmentStatusWidget(status: e.status)
                            ],
                          ),
                        )))
                    .toList(),
              ),
            );
          }),
    );
  }

  bool isDamaged(String status) => status == 'Funcionando';

  bool atLeastOneDamaged(List<Equipment> equipments) =>
      equipments.any((e) => e.status == PageUtils.STATUS_DAMAGED);

  void pushToDepartmentFormView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DepartmentFormView(),
      ),
    );
  }

  void pushToEquipmentDetailsView(
      BuildContext context, Equipment equipment, String departmentDescription) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EquipmentDetailsView(
            equipment: equipment,
            departmentDescription: departmentDescription,
          ),
        ));
  }
}
