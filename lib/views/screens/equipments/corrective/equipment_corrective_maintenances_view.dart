import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/dto/department_dto_model.dart';

import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';
import 'package:tirol_office_app/service/equipment_sevice.dart';
import 'package:tirol_office_app/service/maintenance_service.dart';
import 'package:tirol_office_app/utils/datetime_utils.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/views/screens/equipments/equipment_details_view.dart';
import 'package:tirol_office_app/views/widgets/equipment_status_widget.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class EquipmentCorrectiveMaintenancesView extends StatefulWidget {
  final String equipmentDescription;
  final DepartmentDTO departmentDTO;

  const EquipmentCorrectiveMaintenancesView(
      {Key key,
      @required this.equipmentDescription,
      @required this.departmentDTO})
      : super(key: key);

  @override
  _EquipmentCorrectiveMaintenancesViewState createState() =>
      _EquipmentCorrectiveMaintenancesViewState();
}

class _EquipmentCorrectiveMaintenancesViewState
    extends State<EquipmentCorrectiveMaintenancesView> {
  Equipment currentEquipment;
  String dropdownValue = 'Remover';

  @override
  Widget build(BuildContext context) {
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

    showDeleteDialog(Maintenance maintenance) {
      showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
            builder: (BuildContext localContext, innerSetState) {
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
                        deleteMaintenance(maintenance,
                            widget.equipmentDescription, localContext);
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

    handlingOptionSelected(String value, Maintenance maintenance) async {
      if (value == 'Remover') {
        showDeleteDialog(maintenance);
      } else {
        await MaintenanceService().updateHasOccured(
            widget.departmentDTO.id, widget.equipmentDescription, maintenance);
        setState(() {});
      }
    }

    return FutureBuilder(
      future: EquipmentService()
          .getEquipment(widget.departmentDTO.id, widget.equipmentDescription),
      builder: (context, snapshot) {
        Equipment equipment = snapshot.data;
        return WillPopScope(
          onWillPop: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EquipmentDetailsView(
                    equipmentDescription: equipment.description,
                    departmentDTO: widget.departmentDTO),
              ),
            );
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
                shadowColor: Colors.transparent,
                title: Text("Manutenções corretivas"),
                actions: [
                  IconButton(
                    onPressed: () {
                      RouteUtils.pushToEquipmentCorrectiveMaintenancesFormView(
                          context,
                          widget.equipmentDescription,
                          widget.departmentDTO);
                    },
                    icon: Icon(Icons.add),
                  ),
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
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                EquipmentStatusWidget(
                                  status: equipment.status,
                                )
                              ]),
                          SizedBox(height: 12.0),
                          Text(widget.departmentDTO.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                  ),
                  PageUtils.HORIZONTAL_SEPARATOR_WHITE,
                  equipment.correctiveMaintenances == null ||
                          equipment.correctiveMaintenances.isEmpty
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
                            children: equipment.correctiveMaintenances.map(
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
                                            height: 24,
                                          ),
                                          PageUtils.getAttributeField(
                                              'Provedor do serviço',
                                              maintenance.serviceProvider.name),
                                          SizedBox(
                                            height: 24,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[600]),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                maintenance.hasOccurred
                                                    ? "Concluída"
                                                    : "Aguardando",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    color: defineColorForStatus(
                                                        maintenance)),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Positioned(
                                          top: -10,
                                          right: -12,
                                          child: PopupMenuButton<String>(
                                              onSelected: (value) =>
                                                  handlingOptionSelected(
                                                      value, maintenance),
                                              icon: Icon(Icons.more_vert,
                                                  color: Colors.black),
                                              itemBuilder: (context) =>
                                                  defineOptionsForMaintenance(
                                                          maintenance)
                                                      .map((value) =>
                                                          PopupMenuItem(
                                                              value: value,
                                                              child:
                                                                  Text(value)))
                                                      .toList()))
                                    ]),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color defineColorForStatus(Maintenance maintenance) {
    Color color;
    if (DateTime.now().isAfter(maintenance.dateTime)) {
      if (maintenance.hasOccurred)
        color = Colors.green[700];
      else
        color = color = Colors.yellow[700];
    }
    return color;
  }

  List<String> defineOptionsForMaintenance(Maintenance maintenance) {
    var list = [dropdownValue];
    if (DateTime.now().isAfter(maintenance.dateTime)) {
      if (maintenance.hasOccurred)
        list.insert(0, "Desconcluir");
      else
        list.insert(0, "Concluir");
    }
    return list;
  }
}