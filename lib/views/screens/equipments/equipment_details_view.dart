import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/widgets/equipment_status_widget.dart';

class EquipmentDetailsView extends StatelessWidget {
  final Equipment equipment;
  final String departmentDescription;

  const EquipmentDetailsView(
      {Key key, @required this.equipment, @required this.departmentDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(PageUtils.EQUIPMENT_DETAILS_TITLE)),
      body: Container(
        padding: PageUtils.BODY_PADDING,
        child: Column(
          children: [
            Card(
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
                  Text(departmentDescription,
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.w600))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
