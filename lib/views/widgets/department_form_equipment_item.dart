import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';

class DepartmentFormEquipmentItem extends StatelessWidget {
  final String description;
  final EquipmentStatus status;

  const DepartmentFormEquipmentItem({Key key, this.description, this.status})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Card(
      child: Container(
        height: 90.0,
        padding: EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Positioned(
              child: Text(description,
                  style: Theme.of(context).textTheme.headline6),
            ),
            Positioned(
              //top: 28.0,
              bottom: 0.0,
              child: Row(
                children: [
                  Text(
                    'Status:',
                    style: themeData.textTheme.subtitle1,
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  Text(
                    status == EquipmentStatus.ABLE
                        ? 'Funcionando'
                        : 'Danificado',
                    style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 9.0,
              child: IconButton(
                icon: Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
