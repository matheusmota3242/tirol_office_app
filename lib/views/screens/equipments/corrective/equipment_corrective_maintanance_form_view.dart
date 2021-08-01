import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/mobx/picked_date/picked_date_mobx.dart';
import 'package:tirol_office_app/mobx/service_provider_name/service_provider_name_mobx.dart';
import 'package:tirol_office_app/models/dto/department_dto_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';
import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/service/maintenance_service.dart';
import 'package:tirol_office_app/utils/datetime_utils.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/equipments/corrective/equipment_corrective_maintenances_view.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';

import '../../loading_view.dart';

class EquipmentCorrectiveMaintenanceFormView extends StatefulWidget {
  final Equipment equipment;
  final DepartmentDTO departmentDTO;

  const EquipmentCorrectiveMaintenanceFormView(
      {Key key, @required this.equipment, @required this.departmentDTO})
      : super(key: key);
  _EquipmentCorrectiveMaintenanceFormViewState createState() =>
      _EquipmentCorrectiveMaintenanceFormViewState();
}

class _EquipmentCorrectiveMaintenanceFormViewState
    extends State<EquipmentCorrectiveMaintenanceFormView>
    with TickerProviderStateMixin {
  var serviceProviders = <ServiceProvider>[];
  var serviceProviderNames = <String>[];
  QuerySnapshot snapshot;
  ServiceProviderNameMobx serviceProviderNameMobx = ServiceProviderNameMobx();

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    loadServiceProviders();
  }

  loadServiceProviders() async {
    snapshot = await FirestoreDB.db_service_providers.get();

    setState(() {
      serviceProviders = snapshot.docs
          .map((json) => ServiceProvider.fromJson(json.data()))
          .toList();
      serviceProviderNames = serviceProviders.map((e) => e.name).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Maintenance maintenance = new Maintenance();
    final MaintenanceService service = MaintenanceService();
    final GlobalKey<FormState> _formKey = GlobalKey();
    var pickedDateMobx = PickedDateMobx();
    maintenance.dateTime = pickedDateMobx.getPicked;

    pickDate() async {
      var pickedTimestamp = await Dialogs().showPickDateDialog(context);
      if (pickedTimestamp != null) {
        pickedDateMobx.setPicked(pickedTimestamp);
        maintenance.dateTime = DateTimeUtils.skipTime(pickedTimestamp);
      }
    }

    persist() async {
      if (_formKey.currentState.validate()) {
        ServiceProvider serviceProvider = serviceProviders.firstWhere(
            (element) => element.name == serviceProviderNameMobx.name);
        maintenance.serviceProvider = serviceProvider;
        maintenance.departmentId = widget.departmentDTO.id;
        maintenance.equipmentDescription = widget.equipment.description;

        bool result;
        result = await service.save(maintenance);

        if (result) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EquipmentCorrectiveMaintenancesView(
                        equipment: widget.equipment,
                        departmentDTO: widget.departmentDTO,
                      )));
        }
      }
    }

    // persist() async {
    //   var result;
    //   if (_formKey.currentState.validate()) {
    //     ServiceProvider serviceProvider = serviceProviders
    //         .firstWhere((element) => element.name == serviceProviderValue);
    //     maintenance.serviceProvider = serviceProvider;
    //     if (widget.equipment.correctiveMaintenances == null)
    //       widget.equipment.correctiveMaintenances = [];
    //     widget.equipment.correctiveMaintenances.add(maintenance);
    //     result = await service.saveCorrective(
    //         widget.departmentDTO.id, widget.equipment.id, maintenance);
    //   }

    //   if (result != null)
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (_) => EquipmentCorrectiveMaintenancesView(
    //                   equipmentDescription: widget.equipment.description,
    //                   departmentDTO: widget.departmentDTO,
    //                 )));
    // }

    cancel() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.EQUIPMENT_CORRECTIVE_MAINTENANCE_FORM_TITLE),
      ),
      floatingActionButton:
          PageUtils.getFloatActionButton(_animationController, persist, cancel),
      body: serviceProviders.isNotEmpty
          ? Container(
              padding: PageUtils.BODY_PADDING,
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${widget.departmentDTO.name} - ${widget.equipment.description}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      PageUtils.HORIZONTAL_SEPARATOR_GREY,
                      Text(
                        'Data',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Observer(
                              builder: (_) => Text(
                                    '${DateTimeUtils.toBRFormat(pickedDateMobx.getPicked)}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  )),
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PageUtils.PRIMARY_COLOR),
                            child: IconButton(
                              iconSize: 15,
                              onPressed: () {
                                pickDate();
                              },
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.calendar_today),
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: PageUtils.BODY_PADDING_VALUE),
                      Text(
                        'Prestador de serviço',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                      ),
                      Observer(
                        builder: (_) => DropdownButtonFormField<String>(
                          validator: (value) =>
                              value == null ? 'Selecione um fornecedor' : null,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent))),
                          hint: Text('Selecione'),
                          value: serviceProviderNameMobx.name,
                          onChanged: (String newValue) {
                            serviceProviderNameMobx.setName(newValue);
                          },
                          items: serviceProviderNames
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ]),
              ),
            )
          : LoadingView(),
    );
  }
}
