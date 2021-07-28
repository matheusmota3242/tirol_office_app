import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/mobx/picked_date/picked_date_mobx.dart';
import 'package:tirol_office_app/models/dto/department_dto_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';
import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/service/maintenance_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';

class EquipmentPreventiveMaintananceFormView extends StatefulWidget {
  final String equipmentDescription;
  final DepartmentDTO departmentDTO;

  const EquipmentPreventiveMaintananceFormView(
      {Key key,
      @required this.equipmentDescription,
      @required this.departmentDTO})
      : super(key: key);
  _EquipmentPreventiveMaintananceFormViewState createState() =>
      _EquipmentPreventiveMaintananceFormViewState();
}

class _EquipmentPreventiveMaintananceFormViewState
    extends State<EquipmentPreventiveMaintananceFormView>
    with TickerProviderStateMixin {
  var serviceProviders = <ServiceProvider>[];
  var serviceProviderNames = <String>[];
  AnimationController _animationController;
  QuerySnapshot snapshot;

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
        maintenance.dateTime = pickedTimestamp;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.EQUIPMENT_PREVENTIVE_MAINTENANCE_FORM_TITLE),
      ),
    );
  }
}
