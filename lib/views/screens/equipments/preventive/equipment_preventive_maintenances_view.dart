import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/dto/department_dto_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';

import 'package:tirol_office_app/models/special_equipment_model.dart';
import 'package:tirol_office_app/service/equipment_sevice.dart';
import 'package:tirol_office_app/service/maintenance_service.dart';
import 'package:tirol_office_app/utils/datetime_utils.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/widgets/equipment_status_widget.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class EquipmentPreventiveMaintenancesView extends StatefulWidget {
  final String equipmentDescription;
  final DepartmentDTO departmentDTO;
  const EquipmentPreventiveMaintenancesView(
      {Key key,
      @required this.equipmentDescription,
      @required this.departmentDTO})
      : super(key: key);
  _EquipmentPreventiveMaintenancesViewState createState() =>
      _EquipmentPreventiveMaintenancesViewState();
}

class _EquipmentPreventiveMaintenancesViewState
    extends State<EquipmentPreventiveMaintenancesView> {
  deleteMaintenance(Maintenance maintenance, String equipmentDescription,
      BuildContext dialogContext) async {
    var result = await MaintenanceService().deleteCorrective(
        widget.departmentDTO.id, equipmentDescription, maintenance);
    Navigator.of(dialogContext).pop();
    if (result != null) {
      setState(() {
        Toasts.showToast(content: 'Manutenção removida com sucesso');
      });
    }
  }

  showDeleteDialog(BuildContext context, String equipmentDescription,
      Maintenance maintenance) {
    showDialog(
      context: context,
      builder: (_) =>
          StatefulBuilder(builder: (BuildContext localContext, innerSetState) {
        return AlertDialog(
          title: Text(
            'Remover',
            style: TextStyle(color: Colors.red[500]),
          ),
          content: Text('Você realmente deseja remover esse item?'),
          actions: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      deleteMaintenance(
                          maintenance, equipmentDescription, localContext);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
          appBar: AppBar(
              shadowColor: Colors.transparent,
              title: Text("Manutenções preventivas"),
              actions: [
                IconButton(
                    onPressed: () {
                      RouteUtils.pushToEquipmentPreventiveMaintenancesFormView(
                          context,
                          widget.equipmentDescription,
                          widget.departmentDTO);
                    },
                    icon: Icon(Icons.add))
              ]),
          backgroundColor: PageUtils.PRIMARY_COLOR,
          body: FutureBuilder(
              future: EquipmentService().getEquipment(
                  widget.departmentDTO.id, widget.equipmentDescription),
              builder: (context, snapshot) {
                SpecialEquipment equipment = snapshot.data;

                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  return Container(
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
                                Text(widget.departmentDTO.name,
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                        ),
                        PageUtils.HORIZONTAL_SEPARATOR_WHITE,
                        equipment.preventiveMaintenances == null ||
                                equipment.preventiveMaintenances.isEmpty
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
                            : SingleChildScrollView(
                                child: Column(
                                  children:
                                      equipment.correctiveMaintenances.map(
                                    (maintenance) {
                                      return Card(
                                        margin: EdgeInsets.all(0),
                                        child: Container(
                                          padding: PageUtils.BODY_PADDING,
                                          child: Stack(children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                PageUtils.getAttributeField(
                                                    'Data',
                                                    DateTimeUtils.toBRFormat(
                                                        maintenance.dateTime)),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                PageUtils.getAttributeField(
                                                    'Provedor do serviço',
                                                    maintenance
                                                        .serviceProvider.name),
                                              ],
                                            ),
                                            Positioned(
                                              top: -10,
                                              right: -10,
                                              child: IconButton(
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(Icons.delete,
                                                    color: Colors.black),
                                                onPressed: () {
                                                  showDeleteDialog(
                                                      context,
                                                      equipment.description,
                                                      maintenance);
                                                },
                                              ),
                                            )
                                          ]),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              )
                      ],
                    ),
                  );
                } else {
                  return LoadingView();
                }
              })),
    );
  }
}