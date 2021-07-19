import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:tirol_office_app/mobx/picked_date/picked_date_mobx.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';

class EquipmentCorrectiveMaintenanceFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey();
    var pickedDateMobx = PickedDateMobx();
    pickDate() async {
      var pickedTimestamp = await Dialogs().showProcessFilterDialog(context);
      if (pickedTimestamp != null) pickedDateMobx.setPicked(pickedTimestamp);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(PageUtils.EQUIPMENT_CORRECTIVE_MAINTENANCE_FORM_TITLE),
        ),
        body: Container(
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
                      SizedBox(height: PageUtils.BODY_PADDING_VALUE),
                      Row(
                        children: [
                          Observer(
                              builder: (_) => Text(
                                  '${pickedDateMobx.getPicked.toString()}')),
                          IconButton(
                              onPressed: () {
                                pickDate();
                              },
                              icon: Icon(Icons.calendar_today))
                        ],
                      ),
                    ]))));
  }
}
