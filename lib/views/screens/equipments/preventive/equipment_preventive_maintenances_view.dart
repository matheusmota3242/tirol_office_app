import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/dto/department_dto_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';

import 'package:tirol_office_app/models/special_equipment_model.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/views/widgets/equipment_status_widget.dart';

class EquipmentPreventiveMaintenancesView extends StatelessWidget {
  final SpecialEquipment equipment;
  final DepartmentDTO departmentDTO;

  const EquipmentPreventiveMaintenancesView(
      {Key key, @required this.equipment, @required this.departmentDTO})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Maintenance> preventiveMaintenances = equipment.preventiveMaintenances;
    return Scaffold(
        appBar: AppBar(
            shadowColor: Colors.transparent,
            title: Text("Manutenções preventivas"),
            actions: [
              IconButton(
                  onPressed: () {
                    RouteUtils.pushToEquipmentPreventiveMaintenancesFormView(
                        context);
                  },
                  icon: Icon(Icons.add))
            ]),
        backgroundColor: PageUtils.PRIMARY_COLOR,
        body: Container(
          padding: PageUtils.BODY_PADDING,
          child: ListView(
            children: [
              Card(
                margin: EdgeInsets.all(0),
                child: Container(
                  padding: PageUtils.BODY_PADDING,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(equipment.description,
                                style: Theme.of(context).textTheme.headline4),
                            EquipmentStatusWidget(
                              status: equipment.status,
                            )
                          ]),
                      SizedBox(height: 12.0),
                      Text(departmentDTO.name,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ),
              PageUtils.HORIZONTAL_SEPARATOR_WHITE,
              preventiveMaintenances == null || preventiveMaintenances.isEmpty
                  ? Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: Text(
                          'Não há itens cadastrados',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : ListView(
                      children: preventiveMaintenances
                          .map((cm) => Text(cm.hasOccurred.toString()))
                          .toList(),
                    ),
            ],
          ),
        ));
  }
}
