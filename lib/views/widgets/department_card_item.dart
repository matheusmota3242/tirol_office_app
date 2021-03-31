import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/helpers/route_helper.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/views/screens/departments/department_edit_form_view.dart';

class DepartmentCardItem extends StatefulWidget {
  final Department department;
  final bool lastItem;

  const DepartmentCardItem({Key key, @required this.department, this.lastItem})
      : super(key: key);
  @override
  _DepartmentCardItemState createState() => _DepartmentCardItemState();
}

class _DepartmentCardItemState extends State<DepartmentCardItem> {
  @override
  Widget build(BuildContext context) {
    List<Equipment> equipments = widget.department.equipments;
    var theme = Theme.of(context);
    var heightFactor =
        equipments.length > 0 ? equipments.length - 1 : equipments.length;
    print(heightFactor);
    return Card(
      margin: EdgeInsets.only(bottom: widget.lastItem ? 0 : 16),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 12, 12),
        height: 132.0 + (heightFactor * 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${widget.department.name}',
                      style: theme.textTheme.headline5,
                    ),
                  ),
                  PopupMenuButton(
                    onSelected: (value) => handleChoice(value),
                    //color: Colors.grey[800],
                    padding: EdgeInsets.all(0),
                    itemBuilder: (_) => ['Editar']
                        .map(
                          (choice) => PopupMenuItem<String>(
                            child: Text(choice),
                            value: choice,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 12.0,
            // ),
            Text(
              'Equipamentos',
              style: theme.textTheme.subtitle1,
            ),
            equipments.isNotEmpty
                ? Column(
                    children: equipments
                        .map(
                          (e) => Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Text(e.description),
                                SizedBox(
                                  width: 8.0,
                                ),
                                e.getStatus == "Funcionando"
                                    ? Icon(
                                        Icons.done,
                                        color: Colors.green[400],
                                        size: 20.0,
                                      )
                                    : Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.red[400],
                                        size: 20.0,
                                      ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Column(children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Ainda não há equipamentos cadastrados.',
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  ])
          ],
        ),
      ),
    );
  }

  void handleChoice(String choice) {
    Provider.of<DepartmentService>(context, listen: false).editedDepartment =
        widget.department;

    if (choice == 'Editar') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DepartmentEditFormView(department: widget.department),
        ),
      );
    }
  }
}
