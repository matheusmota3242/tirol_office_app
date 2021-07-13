import 'package:flutter/material.dart';
import 'package:tirol_office_app/helpers/equipment_helper.dart';

class EquipmentStatusWidget extends StatelessWidget {
  final String status;

  const EquipmentStatusWidget({Key key, @required this.status})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 24,
        width: 24,
        child: Icon(
          EquipmentHelper.isDamaged(status)
              ? Icons.done
              : Icons.warning_amber_rounded,
          color: Colors.white,
          size: 16,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                EquipmentHelper.isDamaged(status) ? Colors.green : Colors.red));
  }
}
