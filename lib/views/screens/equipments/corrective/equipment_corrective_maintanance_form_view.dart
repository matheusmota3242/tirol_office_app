import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/mobx/loading/loading_mobx.dart';
import 'package:tirol_office_app/mobx/picked_date/picked_date_mobx.dart';
import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/utils/datetime_utils.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';

import '../../loading_view.dart';

class EquipmentCorrectiveMaintenanceFormView extends StatefulWidget {
  _EquipmentCorrectiveMaintenanceFormViewState createState() =>
      _EquipmentCorrectiveMaintenanceFormViewState();
}

class _EquipmentCorrectiveMaintenanceFormViewState
    extends State<EquipmentCorrectiveMaintenanceFormView> {
  var serviceProviders = <ServiceProvider>[];
  var serviceProviderNames = <String>[];
  QuerySnapshot snapshot;
  String dropdownValue = '--';
  @override
  void initState() {
    super.initState();
    loadServiceProviders();
  }

  loadServiceProviders() async {
    snapshot = await FirestoreDB().db_service_providers.get();

    setState(() {
      serviceProviders = snapshot.docs
          .map((json) => ServiceProvider.fromJson(json.data()))
          .toList();
      serviceProviderNames = serviceProviders.map((e) => e.name).toList();
      serviceProviderNames.insert(0, dropdownValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey();
    var pickedDateMobx = PickedDateMobx();
    var loadingMobx = LoadingMobx();

    pickDate() async {
      var pickedTimestamp = await Dialogs().showPickDateDialog(context);
      if (pickedTimestamp != null) pickedDateMobx.setPicked(pickedTimestamp);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.EQUIPMENT_CORRECTIVE_MAINTENANCE_FORM_TITLE),
      ),
      body: serviceProviders.isNotEmpty
          ? Container(
              padding: PageUtils.BODY_PADDING,
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Observer(
                              builder: (_) => Text(
                                    '${DateTimeUtils.toBRFormat(pickedDateMobx.getPicked)}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  )),
                          SizedBox(width: 8),
                          IconButton(
                              onPressed: () {
                                pickDate();
                              },
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.calendar_today))
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
                      SizedBox(height: 6),
                      DropdownButton<String>(
                        value: dropdownValue,
                        // icon: const Icon(Icons.arrow_downward),
                        // iconSize: 24,

                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
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
                      )
                    ]),
              ),
            )
          : LoadingView(),
    );
  }
}
