import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/mobx/loading/loading_mobx.dart';
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
import 'package:tirol_office_app/views/screens/maintenances/maintenances_view.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';

import '../../loading_view.dart';

class EquipmentCorrectiveMaintenanceFormView extends StatefulWidget {
  final Equipment equipment;
  final DepartmentDTO departmentDTO;
  final Maintenance maintenance;
  final bool edit;
  final bool fromMaintenancesView;

  const EquipmentCorrectiveMaintenanceFormView({
    Key key,
    @required this.equipment,
    @required this.departmentDTO,
    this.edit,
    this.maintenance,
    this.fromMaintenancesView,
  }) : super(key: key);
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
  var pickedDateMobx = PickedDateMobx();
  AnimationController _animationController;
  LoadingMobx loadingMobx = LoadingMobx();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    loadServiceProviders();
    if (widget.edit) {
      pickedDateMobx.setPicked(widget.maintenance.dateTime);
    }
  }

  Future<dynamic> loadServiceProviders() async {
    loadingMobx.setStatus(true);
    snapshot = await FirestoreDB.dbServiceProviders.get();

    serviceProviders = snapshot.docs
        .map((json) => ServiceProvider.fromJson(json.data()))
        .toList();
    serviceProviderNames = serviceProviders.map((e) => e.name).toList();
    setState(() {
      loadingMobx.setStatus(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final MaintenanceService service = MaintenanceService();
    final GlobalKey<FormState> _formKey = GlobalKey();

    widget.maintenance.dateTime = pickedDateMobx.getPicked;
    isEdition() {
      return widget.edit;
    }

    pickDate() async {
      var pickedTimestamp = await Dialogs().showPickDateDialog(context);
      if (pickedTimestamp != null) {
        pickedDateMobx.setPicked(pickedTimestamp);
      }
    }

    if (isEdition()) {
      serviceProviderNameMobx.setName(widget.maintenance.serviceProvider.name);
    }

    persist() async {
      if (_formKey.currentState.validate()) {
        ServiceProvider serviceProvider = serviceProviders.firstWhere(
            (element) => element.name == serviceProviderNameMobx.name);
        widget.maintenance.serviceProvider = serviceProvider;
        widget.maintenance.dateTime =
            DateTimeUtils.skipTime(pickedDateMobx.getPicked);
        bool result;
        if (isEdition())
          result = await service.update(widget.maintenance);
        else {
          widget.maintenance.departmentName = widget.departmentDTO.name;
          widget.maintenance.equipmentDescription =
              widget.equipment.description;
          result = await service.save(widget.maintenance);
        }

        if (result) {
          if (widget.edit)
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MaintenancesView()));
          else
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EquipmentCorrectiveMaintenancesView(
                  equipment: widget.equipment,
                  departmentDTO: widget.departmentDTO,
                ),
              ),
            );
        }
      }
    }

    cancel() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.EQUIPMENT_CORRECTIVE_MAINTENANCE_FORM_TITLE),
      ),
      floatingActionButton: Visibility(
          visible: serviceProviders.isNotEmpty,
          child: PageUtils.getFloatActionButton(
              _animationController, persist, cancel)),
      body: Observer(builder: (_) {
        if (!loadingMobx.status) {
          if (serviceProviders.isNotEmpty)
            return Container(
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
                      PageUtils.horizonalSeparatorGrey,
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
                          hint: isEdition()
                              ? Text(widget.maintenance.serviceProvider.name)
                              : Text('Selecione'),
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
            );
          else
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                'Por favor, cadastre um provedor de serviço antes de cadastrar uma manutenção.',
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ));
        } else {
          return LoadingView();
        }
      }),
    );
  }
}
