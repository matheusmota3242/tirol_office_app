import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/dto/department_dto_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';
import 'package:tirol_office_app/service/maintenance_service.dart';
import 'package:tirol_office_app/utils/datetime_utils.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/views/widgets/equipment_status_widget.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

import '../../loading_view.dart';

class EquipmentCorrectiveMaintenancesView extends StatefulWidget {
  final Equipment equipment;
  final DepartmentDTO departmentDTO;

  const EquipmentCorrectiveMaintenancesView(
      {Key key, @required this.equipment, @required this.departmentDTO})
      : super(key: key);

  @override
  _EquipmentCorrectiveMaintenancesViewState createState() =>
      _EquipmentCorrectiveMaintenancesViewState();
}

class _EquipmentCorrectiveMaintenancesViewState
    extends State<EquipmentCorrectiveMaintenancesView> {
  MaintenanceService _service = MaintenanceService();
  Equipment currentEquipment;
  String dropdownValue = 'Remover';

  @override
  Widget build(BuildContext context) {
    deleteMaintenance(Maintenance maintenance, String equipmentDescription,
        BuildContext dialogContext) async {
      var result = await _service.deleteCorrective(
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
                        Navigator.pop(localContext);
                      },
                      child: Text('Cancelar'),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        deleteMaintenance(maintenance,
                            widget.equipment.description, localContext);
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
        await _service.updateHasOccured(maintenance);
        setState(() {});
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, RouteUtils.DEPARTMENTS);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            shadowColor: Colors.transparent,
            title: Text("Detalhes do equipamento"),
            actions: [
              IconButton(
                onPressed: () {
                  RouteUtils.pushToEquipmentCorrectiveMaintenancesFormView(
                      context: context,
                      equipment: widget.equipment,
                      departmentDTO: widget.departmentDTO,
                      maintenance: Maintenance(),
                      edit: false);
                },
                icon: Icon(Icons.add),
              ),
            ]),
        backgroundColor: PageUtils.PRIMARY_COLOR,
        body: Container(
          padding: PageUtils.BODY_PADDING,
          child: ListView(children: [
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
                          Text(widget.equipment.description,
                              style: Theme.of(context).textTheme.headline4),
                          EquipmentStatusWidget(
                            status: widget.equipment.status,
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

            /* Verificando se snapshot está vazio */
            Container(
              child: FutureBuilder(
                  future: _service.getByEquipmentAndDepartment(
                      widget.departmentDTO.name, widget.equipment.description),
                  builder: (context, snapshot) {
                    var hasError = snapshot.hasError;
                    var hasData = hasError
                        ? false
                        : snapshot.hasData && !snapshot.data.docs.isEmpty;
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.connectionState == ConnectionState.active) {
                      if (hasError)
                        return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Center(
                              child: Text(
                                'Ocorreu um erro',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ));
                      else if (!hasData) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(
                            child: Text(
                              'Não há manutenções cadastradas.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  Maintenance maintenance =
                                      Maintenance.fromJson(
                                          snapshot.data.docs[index].data());
                                  maintenance.id = snapshot.data.docs[index].id;
                                  return InkWell(
                                    onDoubleTap: () => RouteUtils
                                        .pushToEquipmentCorrectiveMaintenancesFormView(
                                            context: context,
                                            departmentDTO: widget.departmentDTO,
                                            equipment: widget.equipment,
                                            maintenance: maintenance,
                                            edit: true),
                                    onLongPress: () =>
                                        showDeleteDialog(maintenance),
                                    child: Card(
                                      margin: EdgeInsets.only(
                                          bottom: PageUtils.BODY_PADDING_VALUE),
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
                                                  maintenance
                                                      .serviceProvider.name),
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
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    maintenance.hasOccurred
                                                        ? "Concluída"
                                                        : "Aguardando",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            defineColorForStatus(
                                                                maintenance)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          DateTime.now().isAfter(maintenance.dateTime)
                                              ? Positioned(
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
                                                                      child: Text(value)))
                                                              .toList()))
                                              : Container()
                                        ]),
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        );
                      }
                    } else {
                      return LoadingView();
                    }
                  }),
            )
          ]),
        ),
      ),
    );
  }

  Color defineColorForStatus(Maintenance maintenance) {
    Color color;
    if (DateTime.now().isAfter(maintenance.dateTime)) {
      if (maintenance.hasOccurred)
        color = Colors.green[700];
      else
        color = Colors.red[700];
    } else {
      color = Colors.yellow[700];
    }
    return color;
  }

  List<String> defineOptionsForMaintenance(Maintenance maintenance) {
    var list = <String>[];
    if (DateTime.now().isAfter(maintenance.dateTime)) {
      if (maintenance.hasOccurred)
        list.insert(0, "Desconcluir");
      else
        list.insert(0, "Concluir");
    }
    return list;
  }
}
