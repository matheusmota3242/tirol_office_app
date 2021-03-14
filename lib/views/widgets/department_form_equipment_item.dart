import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tirol_office_app/helpers/equipment_helper.dart';
import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/service/equipment_sevice.dart';

class DepartmentFormEquipmentItem extends StatelessWidget {
  final Equipment equipment;

  const DepartmentFormEquipmentItem({Key key, @required this.equipment})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final EquipmentService _service = EquipmentService();
    _service.currentEquipment = equipment;

    var equipmentStatusOptions = <String>['Funcionando', 'Danificado'];

    void setEquipmentName(String value) {
      _service.currentEquipment.setDescription(value);
    }

    void selectEquipmentStatus(String value) {
      _service.currentEquipment.setStatus(value);
    }

    Widget cancelButton(BuildContext context) {
      return RaisedButton(
        color: Colors.red,
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Cancelar',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    Widget equipmentNameField(String description) {
      TextEditingController controller =
          TextEditingController(text: description);
      return Container(
        child: TextFormField(
          validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
          onChanged: (value) => setEquipmentName(value.trim()),
          controller: controller,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Descrição',
            labelStyle: TextStyle(
                color: Colors.grey[800],
                height: 0.9,
                fontWeight: FontWeight.w600),
            filled: true,
            counterStyle: TextStyle(color: Colors.red),
            hintText: 'Descrição',
            contentPadding: EdgeInsets.only(
              left: 10.0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    }

    void edit(Equipment equipment) {
      final _formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Novo equipamento'),
          content: Form(
            key: _formKey,
            child: Container(
              height: 190.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  equipmentNameField(equipment.getDescription),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Status atual do equipamento',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 3.0),
                    child: Observer(
                      builder: (_) => DropdownButton<String>(
                        underline: SizedBox(),
                        isExpanded: true,
                        value: _service.currentEquipment.getStatus,
                        onChanged: (value) {
                          selectEquipmentStatus(value);
                        },
                        items: equipmentStatusOptions.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // SizedBox(height: 30.0),
                  // Container(
                  //   alignment: Alignment.center,
                  //   child: Row(
                  //     mainAxisAlignment:
                  //         MainAxisAlignment.spaceEvenly,
                  //     children: [

                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          actions: [
            cancelButton(context),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.of(context).pop(true);
                }
              },
              child: Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ).then((result) {
        if (result) {
          String val = EquipmentHelper().getRoleByEnum(EquipmentStatus.ABLE);
        }
      });
    }

    var themeData = Theme.of(context);
    return Card(
      child: Container(
        height: 90.0,
        padding: EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Positioned(
              child: Text(equipment.getDescription,
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
                    equipment.getStatus ==
                            EquipmentHelper()
                                .getRoleByEnum(EquipmentStatus.ABLE)
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
                onPressed: () => edit(equipment),
                icon: Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
