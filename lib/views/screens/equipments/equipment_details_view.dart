import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/dto/department_dto_model.dart';

import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/special_equipment_model.dart';
import 'package:tirol_office_app/service/equipment_sevice.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/views/screens/departments/department_list_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/widgets/equipment_status_widget.dart';

class EquipmentDetailsView extends StatelessWidget {
  final String equipmentDescription;
  final DepartmentDTO departmentDTO;

  const EquipmentDetailsView(
      {Key key,
      @required this.equipmentDescription,
      @required this.departmentDTO})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute(builder: (_) => DepartmentListView()),
            ModalRoute.withName("/"));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(PageUtils.EQUIPMENT_DETAILS_TITLE)),
        body: FutureBuilder(
            future: EquipmentService()
                .getEquipment(departmentDTO.id, equipmentDescription),
            builder: (context, snapshot) {
              Equipment equipment = snapshot.data;
              if (snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.active) {
                return Container(
                  padding: PageUtils.BODY_PADDING,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                          margin: EdgeInsets.all(0),
                          child: Container(
                            padding: PageUtils.BODY_PADDING,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(equipment.description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
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
                          )),
                      PageUtils.HORIZONTAL_SEPARATOR_GREY,
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Visibility(
                          visible: equipment is SpecialEquipment,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => null,
                                child: Text(
                                  'Manutenções preventivas',
                                  style: PageUtils.textButtonStyle,
                                ),
                              ),
                              SizedBox(height: PageUtils.BODY_PADDING_VALUE),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => RouteUtils
                            .pushToEquipmentCorrectiveMaintenancesView(
                                context, equipment, departmentDTO),
                        child: Text(
                          'Manutenções corretivas',
                          style: PageUtils.textButtonStyle,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return LoadingView();
              }
            }),
      ),
    );
  }
}
