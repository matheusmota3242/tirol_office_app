import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/dto/department_dto_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/departments/department_form_view.dart';
import 'package:tirol_office_app/views/screens/equipments/corrective/equipment_corrective_maintenances_view.dart';
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
                  builder: (_) => DepartmentFormView(
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
        stream: FirestoreDB.departments.orderBy('name').snapshots(),
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

  Widget getPageOnSuccededConnectionState(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) return ErrorView();

    if (!snapshot.hasData)
      return Center(
        child: Text('Vazio'),
      );

    var docs = snapshot.data.docs;

    if (docs.isEmpty)
      return Container(
        color: Colors.white,
        child: Center(
          child: Text(
            'Não há itens cadastrados',
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
      );
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, index) {
            var data = docs[index].data();
            Department department = Department.fromJson(data);
            department.id = docs[index].id;
            for (var i = 0; i < department.equipments.length; i++) {
              department.equipments[i].id = i;
            }
            return Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: InkWell(
                onLongPress: () =>
                    showDeleteDialog(context, department.id, department.name),
                onDoubleTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DepartmentFormView(
                            currentDepartment: department, edit: true))),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.all(0),
                  title: Text(department.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: atLeastOneDamaged(department.equipments)
                              ? Colors.red
                              : Colors.black)),
                  childrenPadding: EdgeInsets.all(0),
                  children: department.equipments
                      .map(
                        (e) => Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: InkWell(
                            onTap: () =>
                                pushToEquipmentCorrectiveMaintenancesView(
                                    context,
                                    e,
                                    new DepartmentDTO(
                                        department.id, department.name)),
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
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          }),
    );
  }

  Widget setBody(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        return LoadingView();
      case ConnectionState.active:
        return getPageOnSuccededConnectionState(context, snapshot);
        break;
      case ConnectionState.none:
        return ErrorView();
        break;
      case ConnectionState.done:
        return getPageOnSuccededConnectionState(context, snapshot);
        break;
    }
  }

  bool isDamaged(String status) => status == 'Funcionando';

  bool atLeastOneDamaged(List<Equipment> equipments) =>
      equipments.any((e) => e.status == PageUtils.STATUS_DAMAGED);

  // void pushToDepartmentFormView(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => null,
  //     ),
  //   );
  // }

  void pushToEquipmentCorrectiveMaintenancesView(
      BuildContext context, Equipment equipment, DepartmentDTO departmentDTO) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EquipmentCorrectiveMaintenancesView(
                equipment: equipment, departmentDTO: departmentDTO)));
  }

  showDeleteDialog(
      BuildContext context, String departmentId, String departmentName) {
    showDialog(
      context: context,
      builder: (_) =>
          StatefulBuilder(builder: (BuildContext localContext, innerSetState) {
        return AlertDialog(
          title: Text(
            'Remover',
            style: TextStyle(color: Colors.red[500]),
          ),
          content: Text(
              'Você realmente deseja remover o departamento $departmentName?'),
          actions: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(localContext);
                    },
                    child: Text('Cancelar'),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      DepartmentService().remove(departmentId);
                      Navigator.pop(localContext);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).buttonColor),
                    ),
                    child: Text('Sim'),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
